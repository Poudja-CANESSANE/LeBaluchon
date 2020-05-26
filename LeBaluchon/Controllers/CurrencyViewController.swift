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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNetworkRequest()
    }

    @IBAction func didTapConvertButton(_ sender: UIButton) {
        updateLabel()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    private let currencyNetworkManager = CurrencyNetworkManager()
    private var usRate: Double = 0

    private func makeNetworkRequest() {
        currencyNetworkManager.getCurrency { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let usRate):
                    self.usRate = usRate
                case .failure(let error):
                    self.presentAlert(with: error.message)
                }
            }
        }
    }

    private func updateLabel() {
        guard let amountToConvert = textField.text else {
            presentAlert(with: "Please enter an amount to convert to dollars $ !")
            return
        }

        guard let amountToConvertFloat = Double(amountToConvert) else {
            presentAlert(with: "Please enter a number !")
            return
        }

        let amount = (amountToConvertFloat * usRate)
        convertedAmountLabel.text = String(format: "%.2f", amount) + "$"
    }

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

