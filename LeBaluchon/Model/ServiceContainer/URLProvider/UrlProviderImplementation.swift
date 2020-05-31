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
        let service = Service.currency
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()
        service.urlParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        return urlComponents.url
    }

    func getTranslationUrl(stringToTranslate: String, targetLanguage: String) -> URL? {
        let service = Service.translation
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()

        service.urlParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        urlComponents.queryItems?.append(URLQueryItem(name: "q", value: stringToTranslate))
        urlComponents.queryItems?.append(URLQueryItem(name: "target", value: targetLanguage))
        return urlComponents.url
    }

    func getWeatherUrl(city: City) -> URL? {
        let service = Service.weather
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()
        service.urlParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems?.append(URLQueryItem(name: "q", value: city.name))

        return urlComponents.url
    }

    func getWeatherIconUrl(iconId: String) -> URL? {
        let service = Service.weatherIcon
        var weatherIconBaseUrl = service.baseUrl
        weatherIconBaseUrl.append(contentsOf: "\(iconId)@2x.png")
        let weatherIconUrl = URL(string: weatherIconBaseUrl)
        print("\(String(describing: weatherIconUrl)) weatherIconUrl " + #function)
        return weatherIconUrl
    }
}
