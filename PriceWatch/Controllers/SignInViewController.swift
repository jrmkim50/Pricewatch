//
//  SignInViewController.swift
//  PriceWatch
//
//  Created by Min on 3/17/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        setGradientBackground(rgbTop: [70.0, 153.0, 239.0], rgbBottom: [51.0, 116.0, 239.0])
        
        emailTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
        
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        UserService.logInUser(email: email, password: password, completion: {(user) in
            if let userObject = user {
                User.setCurrent(user: userObject, writeToUserDefaults: true)
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        })
    }

}
