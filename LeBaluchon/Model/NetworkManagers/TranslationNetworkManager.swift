//
//  TranslateNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class TranslationNetworkManager {
    func translate(textToTranslate: String, targetLanguage: String, completion: @escaping (Result<Translation, NetworkError>) -> ()) {
        guard let translationUrl = ServiceContainer.urlProviderImplementation.getUrl(service: .translation, stringToTranslate: textToTranslate, targetLanguage: targetLanguage, city: nil) else {
            completion(.failure(.cannotGetUrl))
            return
        }
        print(translationUrl)
        ServiceContainer.networkManager.fetchData(url: translationUrl) { (result: Result<TranslationResult, NetworkError>) in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let response):
                let translation = self.createTranslation(fromResponse: response)
                completion(.success(translation))
            }
        }
    }

    private func createTranslation(fromResponse response: TranslationResult) -> Translation {
        print(response)
        var translatedText = response.data.translations[0].translatedText
        let detectedSourceLanguage = response.data.translations[0].detectedSourceLanguage

        if translatedText.contains("&#39;") || translatedText.contains("&quot;"){
            translatedText = translatedText.replacingOccurrences(of: "&#39;", with: "‘")
            translatedText = translatedText.replacingOccurrences(of: "&quot;", with: "\"")
        }

        let translation = Translation(translatedText: translatedText, detectedSourceLanguage: detectedSourceLanguage)
        return translation
    }
    
}
