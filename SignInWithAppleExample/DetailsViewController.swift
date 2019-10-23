//
//  SignInDetails.swift
//  SignInWithAppleExample
//
//  Created by John Codeos on 10/23/19.
//  Copyright © 2019 John Codeos. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var userid: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var email: String = ""
    
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdLabel.text = userid
        firstNameLabel.text = firstname
        lastNameLabel.text = lastname
        emailLabel.text = email
    }

}
