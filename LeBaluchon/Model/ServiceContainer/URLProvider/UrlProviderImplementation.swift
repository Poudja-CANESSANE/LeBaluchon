//
//  UrlProviderImplementation.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 22/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class UrlProviderImplementation: UrlProvider {
    func getLatestCurrencyUrl() -> URL? {
        let service = Services.currency
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()
        service.urlParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        return urlComponents.url
    }
    
    func getTranslationUrl(stringToTranslate: String, targetLanguage: String) -> URL? {
        let service = Services.translation
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()

        service.urlParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        urlComponents.queryItems?.append(URLQueryItem(name: "q", value: stringToTranslate))
        urlComponents.queryItems?.append(URLQueryItem(name: "target", value: targetLanguage))
        return urlComponents.url
    }

    func getWeatherUrl(city: Cities) -> URL? {
        let service = Services.weather
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()
        service.urlParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems?.append(URLQueryItem(name: "q", value: city.name))

        return urlComponents.url
    }

    func getUrl(service: Services, stringToTranslate: String? = nil, targetLanguage: String? = nil, city: Cities? = nil) -> URL? {
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()
        service.urlParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        switch service {
        case .currency: return urlComponents.url
        case .translation:
            guard let stringToTranslate = stringToTranslate else {return nil}
            guard let targetLanguage = targetLanguage else {return nil}
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: stringToTranslate))
            urlComponents.queryItems?.append(URLQueryItem(name: "target", value: targetLanguage))
        case .weather:
            guard let city = city else {return nil}
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: city.name))
        }

        return urlComponents.url
    }
    
}
