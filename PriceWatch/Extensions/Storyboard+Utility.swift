//
//  Storyboard+Utility.swift
//  PriceWatch
//
//  Created by Min on 3/18/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum PWType: String {
        case main
        case login

        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: PWType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: PWType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }

        return initialViewController
    }
}
