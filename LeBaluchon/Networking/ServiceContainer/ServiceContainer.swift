//
//  ServiceContainer.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 22/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class ServiceContainer {
    static let currencyUrlProvider: CurrencyUrlProvider = CurrencyUrlProviderImplementation()
    static let translationUrlProvider: TranslationUrlProvider = TranslationUrlProviderImplementation()
    static let weatherUrlProvider: WeatherUrlProvider = WeatherUrlProviderImplementation()
    static let networkService: NetworkService = NetworkServiceImplementation()
    static let alertManager = AlertManager()
}
