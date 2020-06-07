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
        networkService: ServiceContainer.networkService,
        currencyUrlProvider: ServiceContainer.currencyUrlProvider)

    private let alertManager = ServiceContainer.alertManager
    private var usRate: Double = 0



    // MARK: Methods

    ///Gets the downloaded us rate
    private func makeNetworkRequest() {
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
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
        guard let amountToConvertString = textField.text?.replacingOccurrences(of: ",", with: ".") else {
            presentAlert(msg: "Please enter an amount to convert to dollars $ !")
            return
        }

        guard let amountToConvertDouble = Double(amountToConvertString) else {
            presentAlert(msg: "Please enter a number !")
            return
        }

        let amount = (amountToConvertDouble * usRate)
        let formattedAmount = formatConvertedAmount(amount: amount)
        convertedAmountLabel.text = formattedAmount + "$"
    }

    ///Returns the given amount with spaces and comma to make it more readable
    private func formatConvertedAmount(amount: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale(identifier: "fr_FR")
        guard var formattedAmount = currencyFormatter.string(from: NSNumber(value: amount)) else { return "" }
        formattedAmount = String(formattedAmount.dropLast())
        return formattedAmount
    }

    ///Presents an alert with the given message
    private func presentAlert(msg: String) {
        alertManager.presentErrorAlert(with: msg, presentingViewController: self)
    }
}
