//
//  TranslateNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class TranslationNetworkManager {
    private let networkManager: NetworkManager
    private let urlProvider: UrlProvider

    init(networkManager: NetworkManager,
         urlProvider: UrlProvider) {
        self.networkManager = networkManager
        self.urlProvider = urlProvider
    }

    func translate(
        textToTranslate: String,
        targetLanguage: String,
        completion: @escaping (Result<Translation, NetworkError>) -> Void) {
        guard let translationUrl = urlProvider.getTranslationUrl(
            stringToTranslate: textToTranslate,
            targetLanguage: targetLanguage) else {
            completion(.failure(.cannotGetUrl))
            return
        }
        print(translationUrl)
        networkManager.fetchData(url: translationUrl) { (result: Result<TranslationResult, NetworkError>) in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let response):
                do {
                    let translation = try self.createTranslation(fromResponse: response)
                    completion(.success(translation))
                } catch {
                    guard let error = error as? NetworkError else {return}
                    completion(.failure(error))
                }
            }
        }
    }

    private func createTranslation(fromResponse response: TranslationResult) throws -> Translation {
        print(response)
        guard var translatedText = response.data.translations.first?.translatedText else {
            throw NetworkError.cannotCreateTranslation
        }

        guard let detectedSourceLanguage = response.data.translations.first?.detectedSourceLanguage else {
            throw  NetworkError.cannotCreateTranslation
        }

        if translatedText.contains("&#39;") || translatedText.contains("&quot;") {
            translatedText = translatedText.replacingOccurrences(of: "&#39;", with: "‘")
            translatedText = translatedText.replacingOccurrences(of: "&quot;", with: "\"")
        }

        let translation = Translation(translatedText: translatedText, detectedSourceLanguage: detectedSourceLanguage)
        return translation
    }
}
