//
//  AlertManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 28/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    func presentAlert(with message: String, presentingViewController: UIViewController) {
        let alertViewController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .cancel)
        alertViewController.addAction(action)
        presentingViewController.present(alertViewController, animated: true)
    }
}
