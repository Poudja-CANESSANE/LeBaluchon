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

    // MARK: Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        convertButton.layer.cornerRadius = 7
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeNetworkRequest()
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var convertedAmountLabel: UILabel!
    @IBOutlet private weak var convertButton: UIButton!



    // MARK: IBActions

    @IBAction private func didTapConvertButton(_ sender: UIButton) {
        updateConvertedAmountLabel()
    }

    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    // MARK: Properties

    private let currencyNetworkManager = CurrencyNetworkManager(
        networkService: ServiceContainer.networkService,
        currencyUrlProvider: ServiceContainer.currencyUrlProvider)

    private let alertManager = ServiceContainer.alertManager
    private var usRate: Double = 0



    // MARK: Methods

    ///Gets the downloaded us rate
    private func makeNetworkRequest() {
        currencyNetworkManager.getLatestUSDCurrencyRate { [weak self] result in
            guard let self = self else { return }
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

    ///Updates convertedAmountLabel with converted and formatted amount
    private func updateConvertedAmountLabel() {
        guard let amountToConvertString = textField.text?.replacingOccurrences(of: ",", with: ".") else {
            presentAlert(msg: "Please enter an amount to convert to dollars $ !")
            return
        }

        guard let amountToConvertDouble = Double(amountToConvertString) else {
            presentAlert(msg: "Please enter a number !")
            return
        }

        let convertedAmount = amountToConvertDouble * usRate
        let formattedAmount = format(amount: convertedAmount)
        convertedAmountLabel.text = formattedAmount + "$"
    }

    ///Returns the given amount with spaces and comma to make it more readable
    private func format(amount: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale(identifier: "fr_FR")
        guard var formattedAmount = currencyFormatter.string(from: NSNumber(value: amount)) else {
            presentAlert(msg: "Cannot format the converted amount !")
            return "" }
        formattedAmount = String(formattedAmount.dropLast())
        return formattedAmount
    }

    ///Presents an alert with the given message
    private func presentAlert(msg: String) {
        alertManager.presentErrorAlert(with: msg, presentingViewController: self)
    }
}
