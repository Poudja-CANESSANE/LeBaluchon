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

    init(networkService: NetworkService,
         translationUrlProvider: TranslationUrlProvider) {
        self.networkService = networkService
        self.translationUrlProvider = translationUrlProvider
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded translation in the given target language
    func getTranslation(
        forTextToTranslate textToTranslate: String,
        inTargetLanguage targetLanguage: String,
        completion: @escaping (Result<Translation, NetworkError>) -> Void) {

        guard let translationUrl = translationUrlProvider.getTranslationUrl(
            stringToTranslate: textToTranslate,
            targetLanguage: targetLanguage) else {
            completion(.failure(.cannotGetUrl))
            return
        }

        networkService.fetchData(url: translationUrl) { (result: Result<TranslationResult, NetworkError>) in
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

    private let networkService: NetworkService
    private let translationUrlProvider: TranslationUrlProvider



    // MARK: Methods

    ///Returns a Translation from the given TranslationResult without the HTML character references
    private func createTranslation(fromResponse response: TranslationResult) throws -> Translation {
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

    private func replacePotential(
        _ stringToReplace: String,
        with replacementString: String,
        in originalString: String) -> String {

        let formattedString = originalString.contains(stringToReplace) ?
            originalString.replacingOccurrences(of: stringToReplace, with: replacementString) : originalString
        return formattedString
    }
}
