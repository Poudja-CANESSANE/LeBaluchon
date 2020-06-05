//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 12/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController {
    // MARK: - INTERNAL

    // MARK: IBOutlets

    @IBOutlet weak var toTranslateTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var detectedSourceLanguageLabel: UILabel!
    @IBOutlet weak var targetLanguageSegmentedControl: UISegmentedControl!



    // MARK: IBActions

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        toTranslateTextView.resignFirstResponder()
    }

    @IBAction func didTapTranslateButton(_ sender: UIButton) {
        makeNetworkRequest()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let translationNetworkManager = TranslationNetworkManager(
        networkService: ServiceContainer.networkService,
        translationUrlProvider: ServiceContainer.translationUrlProvider)

    private let alertManager = ServiceContainer.alertManager
    private let activityIndicatorViewManager = ActivityIndicatorViewManager()



    // MARK: Methods

    ///Gets the downloaded translation 
    private func makeNetworkRequest() {
        activityIndicatorViewManager.setupActivityIndicator(on: view)
        let targetLanguage = getTargetLanguage()

        translationNetworkManager.getTranslation(
        forTextToTranslate: toTranslateTextView.text,
        inTargetLanguage: targetLanguage) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.activityIndicatorViewManager.removeActivityIndicator()
                    self.presentAlert(msg: networkError.message)
                case .success(let translation):
                    self.activityIndicatorViewManager.removeActivityIndicator()
                    self.updateLabels(translation: translation)
                }
            }
        }
    }

    ///Returns the chosen target language
    private func getTargetLanguage() -> String {
        var targetLanguage: String
        switch targetLanguageSegmentedControl.selectedSegmentIndex {
        case 0: targetLanguage = "en"
        case 1: targetLanguage = "fr"
        case 2: targetLanguage = "de"
        case 3: targetLanguage = "es"
        default: targetLanguage = "en"
        }
        return targetLanguage
    }

    ///Updates the labels with the given Translation
    private func updateLabels(translation: Translation) {
        translatedTextView.text = translation.translatedText
        detectedSourceLanguageLabel.text = "Detected Source Language: \(translation.detectedSourceLanguage)"
    }

    ///Presents an alert with the given message
    private func presentAlert(msg: String) {
        alertManager.presentErrorAlert(with: msg, presentingViewController: self)
    }
}
