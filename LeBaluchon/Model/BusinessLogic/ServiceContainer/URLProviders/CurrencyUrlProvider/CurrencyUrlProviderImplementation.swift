//
//  CurrencyUrlProviderImplementation.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 04/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class CurrencyUrlProviderImplementation: CurrencyUrlProvider {
    ///Returns an optionnal URL to get the latest currency rates from the data.fixer.io API
    func getLatestCurrencyUrl() -> URL? {
        let service = Service.currency
        guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

        urlComponents.queryItems = [URLQueryItem]()
        service.urlParameters.forEach { urlComponents.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value)) }

        return urlComponents.url
    }
}
