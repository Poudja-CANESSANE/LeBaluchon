//
//  TranslationUrlProviderImplementation.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 04/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class TranslationUrlProviderImplementation: TranslationUrlProvider {
    ///Returns an optionnal URL to get the translation for the given String in the given target language
    ///from the translation.googleapis.com API
    func getTranslationUrl(stringToTranslate: String, targetLanguage: String) -> URL? {
        let translationFunctionality = Functionality.translation
        guard var urlComponents = URLComponents(string: translationFunctionality.baseUrl) else { return nil }

        translationFunctionality.urlParameters.forEach { urlComponents.queryItems?.append(
            URLQueryItem(name: $0.key, value: $0.value)) }

        urlComponents.queryItems?.append(URLQueryItem(name: "q", value: stringToTranslate))
        urlComponents.queryItems?.append(URLQueryItem(name: "target", value: targetLanguage))

        return urlComponents.url
    }
}
