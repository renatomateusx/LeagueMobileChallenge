//
//  UIViewController+Extensions.swift
//  LeagueMobileChallenge
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true)
            completion?()
        }))
        self.present(alert, animated: true)
    }
}

