//
//  LoginViewController.swift
//  PriceWatch
//
//  Created by Min on 3/17/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

typealias FIRUser = FirebaseAuth.User

class StartupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(rgbTop: [70.0, 153.0, 239.0], rgbBottom: [51.0, 116.0, 239.0])
        // Do any additional setup after loading the view.
    }

}
