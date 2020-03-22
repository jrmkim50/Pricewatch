//
//  ViewController.swift
//  PriceWatch
//
//  Created by Min on 3/15/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(rgbTop: [70.0, 153.0, 239.0], rgbBottom: [51.0, 116.0, 239.0])
        // Do any additional setup after loading the view.
    }

}

extension UIViewController {
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    func setGradientBackground(rgbTop: [CGFloat], rgbBottom: [CGFloat]) {
        let colorTop =  UIColor(red: rgbTop[0]/255.0, green: rgbTop[1]/255.0, blue: rgbTop[2]/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: rgbBottom[0]/255.0, green: rgbBottom[1]/255.0, blue: rgbBottom[2]/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

