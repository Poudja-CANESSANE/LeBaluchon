//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 12/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    // MARK: - INTERNAL

    // MARK: IBOutlets

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertedAmountLabel: UILabel!



    // MARK: IBActions

    @IBAction func didTapConvertButton(_ sender: UIButton) {
        updateLabel()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }



    // MARK: Methods

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeNetworkRequest()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let currencyNetworkManager = CurrencyNetworkManager(
        networkManager: ServiceContainer.networkManager,
        urlProvider: ServiceContainer.urlProvider)

    private let alertManager = ServiceContainer.alertManager
    private var usRate: Double = 0



    // MARK: Methods

    ///Gets the downloaded us rate
    private func makeNetworkRequest() {
        currencyNetworkManager.getCurrency { result in
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

    ///Updates the convertedAmountLabel with converted amount
    private func updateLabel() {
        guard let amountToConvertString = textField.text else {
            presentAlert(msg: "Please enter an amount to convert to dollars $ !")
            return
        }

        guard let amountToConvertDouble = Double(amountToConvertString) else {
            presentAlert(msg: "Please enter a number !")
            return
        }

        let amount = (amountToConvertDouble * usRate)
        convertedAmountLabel.text = String(format: "%.2f", amount) + "$"
    }

    ///Presents an alert with the given message
    private func presentAlert(msg: String) {
        alertManager.presentAlert(with: msg, presentingViewController: self)
    }
}
