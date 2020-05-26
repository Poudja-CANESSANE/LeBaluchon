//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 12/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController {
    @IBOutlet weak var toTranslateTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var detectedSourceLanguageLabel: UILabel!
    @IBOutlet weak var targetLanguageSegmentedControl: UISegmentedControl!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        toTranslateTextView.resignFirstResponder()
    }

    @IBAction func didTapTranslateButton(_ sender: UIButton) {
        makeNetworkRequest()
    }
    
    private let translationNetworkManager = TranslationNetworkManager()

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
    
    private func makeNetworkRequest() {
        let targetLanguage = getTargetLanguage()
        translationNetworkManager.translate(textToTranslate: toTranslateTextView.text, targetLanguage: targetLanguage) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message)
                case .success(let translation):
                    self.translatedTextView.text = translation.translatedText
                    self.detectedSourceLanguageLabel.text = "Detected Source Language: \(translation.detectedSourceLanguage)"
                }
            }
        }
    }

    private func presentAlert(msg: String) {
        let alertViewController = UIAlertController(
            title: "Error",
            message: msg,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertViewController.addAction(action)
        present(alertViewController,animated: true)
    }
}
