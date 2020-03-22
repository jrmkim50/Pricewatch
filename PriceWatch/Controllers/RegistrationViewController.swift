//
//  RegistrationViewController.swift
//  PriceWatch
//
//  Created by Min on 3/17/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController {
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        setGradientBackground(rgbTop: [70.0, 153.0, 239.0], rgbBottom: [51.0, 116.0, 239.0])
        
        nameTextField.clipsToBounds = true
        emailTextField.clipsToBounds = true
        usernameTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
        
        nameTextField.layer.cornerRadius = 20
        emailTextField.layer.cornerRadius = 20
        usernameTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
    }
   
    @IBAction func registrationButton(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let email = emailTextField.text, email.contains("@") else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        UserService.createUser(name: name, email: email, username: username, password: password, completion: {(user) in
            if let userObject = user {
                User.setCurrent(user: userObject, writeToUserDefaults: true)
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                let errorAlertController = UIAlertController(title: "Could not register!", message: "Make sure your password is at least 6 characters and choose a username that hasn't been taken already!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                return
            }
        })
    }
}
