//
//  ViewController.swift
//  SignInWithAppleExample
//
//  Created by John Codeos on 10/23/19.
//  Copyright © 2019 John Codeos. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    var userId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Default 'Sign in with Apple' button
        appleLoginButton()
        
        // Custom 'Sign in with Apple' button
        //appleCustomLoginButton()
    }

    // 'Sign in with Apple' button using ASAuthorizationAppleIDButton class
    func appleLoginButton() {
        if #available(iOS 13.0, *) {
            let appleLoginBtn = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
            appleLoginBtn.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.view.addSubview(appleLoginBtn)
            // Setup Layout Constraints to be in the center of the screen
            appleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                appleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                appleLoginBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                appleLoginBtn.widthAnchor.constraint(equalToConstant: 200),
                appleLoginBtn.heightAnchor.constraint(equalToConstant: 40)
                ])
        }
    }

    // Custom 'Sign in with Apple' button
    func appleCustomLoginButton() {
        if #available(iOS 13.0, *) {
            let customAppleLoginBtn = UIButton()
            customAppleLoginBtn.layer.cornerRadius = 20.0
            customAppleLoginBtn.layer.borderWidth = 2.0
            customAppleLoginBtn.backgroundColor = UIColor.white
            customAppleLoginBtn.layer.borderColor = UIColor.black.cgColor
            customAppleLoginBtn.setTitle("Sign in with Apple", for: .normal)
            customAppleLoginBtn.setTitleColor(UIColor.black, for: .normal)
            customAppleLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            customAppleLoginBtn.setImage(UIImage(named: "apple"), for: .normal)
            customAppleLoginBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
            customAppleLoginBtn.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.view.addSubview(customAppleLoginBtn)
            // Setup Layout Constraints to be in the center of the screen
            customAppleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customAppleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                customAppleLoginBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                customAppleLoginBtn.widthAnchor.constraint(equalToConstant: 200),
                customAppleLoginBtn.heightAnchor.constraint(equalToConstant: 40)
                ])
        }
    }
    
    func getCredentialState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "USER_ID") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // Credential is valid
                // Continiue to show 'User's Profile' Screen
                break
            case .revoked:
                // Credential is revoked.
                // Show 'Sign In' Screen
                break
            case .notFound:
                // Credential not found.
                // Show 'Sign In' Screen
                break
            default:
                break
            }
        }
    }

    @objc func actionHandleAppleSignin() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailseg" {
            let DestView = segue.destination as! DetailsViewController
            DestView.userid = self.userId
            DestView.firstname = self.firstName
            DestView.lastname = self.lastName
            DestView.email = self.email
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {

    // Authorization Failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }


    // Authorization Succeeded
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let appleId = appleIDCredential.user
            userId = appleId
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            firstName = appleUserFirstName ?? ""
            let appleUserLastName = appleIDCredential.fullName?.familyName
            lastName = appleUserLastName ?? ""
            let appleUserEmail = appleIDCredential.email
            email = appleUserEmail ?? ""
            performSegue(withIdentifier: "detailseg", sender: self)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Get user data using an existing iCloud Keychain credential
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            // Write your code
        }
    }

}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
