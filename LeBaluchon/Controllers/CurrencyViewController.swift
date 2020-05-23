//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 12/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertedAmountLabel: UILabel!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    @IBAction func didTapConvertButton(_ sender: UIButton) {
        makeNetworkRequest()
    }

    private func makeNetworkRequest() {
        currencyNetworkManager.getCurrency { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let usRate):
                    self.updateLabel(with: usRate)
                case .failure(let error):
                    self.presentAlert(with: error.message)
                }
            }
        }
    }

    private func updateLabel(with usRate: Double) {
        guard let amountToConvert = self.textField.text else { return }
        guard let amountToConvertFloat = Float(amountToConvert) else { return }
        let amount = (amountToConvertFloat * Float(usRate))
        self.convertedAmountLabel.text = String(format: "%.2f", amount) + "$"
    }

    private let currencyNetworkManager = CurrencyNetworkManager()

    private func presentAlert(with message: String) {
        let alertViewController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertViewController.addAction(action)
        present(alertViewController,animated: true)
    }
}

