//
//  UIViewController+Extension.swift
//  ChatApp
//
//  Created by Chau Vo on 7/11/16.
//  Copyright © 2016 Chau Vo. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, content: String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
