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
    
    @IBAction func didTapTranslateButton(_ sender: UIButton) {
        TranslationNetworkManager.shared.translate(textToTranslate: toTranslateTextView.text) { (result) in
            switch result {
            case .failure(let networkError):
                print(networkError)
            case .success(let translation):
                guard let translation = translation else {
                    print("Cannnot unwrap translation !")
                    return
                }
                self.translatedTextView.text = translation.translatedText
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
