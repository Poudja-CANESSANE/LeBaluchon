//
//  CurrencuNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class CurrencyNetworkManager {
    func getUrl(service: Services, stringToTranslate: String? = nil, city: Cities? = nil) -> URL? {
            guard var urlComponents = URLComponents(string: service.baseUrl) else { return nil }

            urlComponents.queryItems = [URLQueryItem]()
            service.urlParameters.forEach { (key, value) in
                urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            switch service {
            case .currency: return urlComponents.url
            case .translation:
                guard let stringToTranslate = stringToTranslate else {return nil}
                urlComponents.queryItems?.append(URLQueryItem(name: "q", value: stringToTranslate))
            case .weather:
                guard let city = city else {return nil}
                urlComponents.queryItems?.append(URLQueryItem(name: "q", value: city.name))
            }

            return urlComponents.url
        }

    func getCurrency(completion: @escaping (Result<Double, NetworkError>) -> Void) {
        guard let latestCurrencyUrl = getUrl(service: .currency) else {
            completion(.failure(.cannotGetUrl))
            return
        }
        print(latestCurrencyUrl)

        ServiceContainer.networkManager.fetchData(url: latestCurrencyUrl) { (result: Result<CurrencyLatestResult, NetworkError>) in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let response):
                guard let usRate = response.rates["USD"] else {
                    completion(.failure(.cannotUnwrapUsRate))
                    return
                }

                completion(.success(usRate))
            }
        }
    }
}
