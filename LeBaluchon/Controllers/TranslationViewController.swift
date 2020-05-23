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

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        toTranslateTextView.resignFirstResponder()
    }

    @IBAction func didTapTranslateButton(_ sender: UIButton) {
        makeNetworkRequest()
    }
    
    private let translationNetworkManager = TranslationNetworkManager()

    private func makeNetworkRequest() {
        translationNetworkManager.translate(textToTranslate: toTranslateTextView.text) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message)
                case .success(let translation):
                    self.translatedTextView.text = translation.translatedText
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
