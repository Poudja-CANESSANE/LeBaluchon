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

    typealias TranslationCompletion = (Result<Translation, NetworkError>) -> Void



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
        completion: @escaping TranslationCompletion) {

        guard let translationUrl = translationUrlProvider.getTranslationUrl(
            stringToTranslate: textToTranslate,
            targetLanguage: targetLanguage) else {
            completion(.failure(.cannotGetUrl))
            return
        }

        networkService.fetchData(url: translationUrl) { [weak self] (result: Result<TranslationResult, NetworkError>) in
            switch result {
            case .failure(let networkError):
                completion(.failure(networkError))
            case .success(let response):
                self?.handleSucessfulTranslationResponse(response: response, completion: completion)
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkService: NetworkService
    private let translationUrlProvider: TranslationUrlProvider



    // MARK: Methods

    ///Returns by the completion parameter a Translation built from the TranslationResult
    private func handleSucessfulTranslationResponse(
        response: TranslationResult,
        completion: @escaping TranslationCompletion) {

        let translationResult = createTranslation(fromResponse: response)

        switch translationResult {
        case .failure(let networkError): completion(.failure(networkError))
        case .success(let translation): completion(.success(translation))
        }
    }

    ///Returns a Translation from the given TranslationResult without the HTML character references
    private func createTranslation(fromResponse response: TranslationResult) -> Result<Translation, NetworkError> {

        guard let firstTranslation = response.data.translations.first else {
            return .failure(.cannotUnwrapFirstTranslation)
        }

        let translatedText = firstTranslation.translatedText
        let detectedSourceLanguage = firstTranslation.detectedSourceLanguage
        let encodedTranslatedText = replaceHTMLCharacterReferences(forString: translatedText)

        let translation = Translation(
            translatedText: encodedTranslatedText,
            detectedSourceLanguage: detectedSourceLanguage)
        return .success(translation)
    }

    ///Returns the given String by replacing the HTML character references by the corresponding character
    private func replaceHTMLCharacterReferences(forString string: String) -> String {
        var formattedString = string
        formattedString = replacePotential("&#39;", with: "‘", in: formattedString)
        formattedString = replacePotential("&quot;", with: "\"", in: formattedString)
        formattedString = replacePotential("&amp;", with: "&", in: formattedString)
        formattedString = replacePotential("&lt;", with: "<", in: formattedString)
        formattedString = replacePotential("&gt;", with: ">", in: formattedString)
        return formattedString
    }

    ///Returns the given String by replacing the given HTML character reference by the given replacement String
    private func replacePotential(
        _ stringToReplace: String,
        with replacementString: String,
        in originalString: String) -> String {

        let formattedString = originalString.contains(stringToReplace) ?
            originalString.replacingOccurrences(of: stringToReplace, with: replacementString) : originalString
        return formattedString
    }
}
