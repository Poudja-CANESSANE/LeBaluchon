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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeNetworkRequest()
    }

    @IBAction func didTapConvertButton(_ sender: UIButton) {
        updateLabel()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    private let currencyNetworkManager = CurrencyNetworkManager(
        networkManager: ServiceContainer.networkManager,
        urlProvider: ServiceContainer.urlProvider)

    private let alertManager = ServiceContainer.alertManager
    private var usRate: Double = 0

    private func makeNetworkRequest() {
        currencyNetworkManager.getCurrency { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let usRate):
                    self.usRate = usRate
                case .failure(let error):
                    self.presentAlert(msg: error.message)
                }
            }
        }
    }

    private func updateLabel() {
        guard let amountToConvert = textField.text else {
            presentAlert(msg: "Please enter an amount to convert to dollars $ !")
            return
        }

        guard let amountToConvertFloat = Double(amountToConvert) else {
            presentAlert(msg: "Please enter a number !")
            return
        }

        let amount = (amountToConvertFloat * usRate)
        convertedAmountLabel.text = String(format: "%.2f", amount) + "$"
    }

    private func presentAlert(msg: String) {
        alertManager.presentAlert(with: msg, presentingViewController: self)
    }
}
