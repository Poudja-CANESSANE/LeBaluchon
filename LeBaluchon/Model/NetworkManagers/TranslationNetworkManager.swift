//
//  TranslateNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class TranslationNetworkManager {
    // MARK: - INTERNAL

    // MARK: Inits

    init(networkManager: NetworkManager,
         urlProvider: UrlProvider) {
        self.networkManager = networkManager
        self.urlProvider = urlProvider
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded translation in the given target language
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



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkManager: NetworkManager
    private let urlProvider: UrlProvider



    // MARK: Methods

    ///Returns a Translation from the given TranslationResult without the HTML character references
    private func createTranslation(fromResponse response: TranslationResult) throws -> Translation {
        print(response)
        guard var translatedText = response.data.translations.first?.translatedText else {
            throw NetworkError.cannotCreateTranslation
        }

        guard let detectedSourceLanguage = response.data.translations.first?.detectedSourceLanguage else {
            throw  NetworkError.cannotCreateTranslation
        }

        translatedText = replaceHTMLCharacterReferences(forString: translatedText)

        let translation = Translation(translatedText: translatedText, detectedSourceLanguage: detectedSourceLanguage)
        return translation
    }

    ///Returns the given String by replacing the HTML character references by the corresponding character
    private func replaceHTMLCharacterReferences(forString string: String) -> String {
        var formattedString = string
        formattedString = replacePotential("&#39;", with: "‘", in: formattedString)
        formattedString = replacePotential("&quot;", with: "\"", in: formattedString)
        return formattedString
    }

    private func replacePotential(_ string1: String, with string2: String, in string3: String) -> String {
        let formattedString = string3.contains(string1) ?
            string3.replacingOccurrences(of: string1, with: string2) : string3
        return formattedString
    }
}
