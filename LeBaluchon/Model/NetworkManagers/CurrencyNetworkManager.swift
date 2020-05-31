//
//  CurrencuNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class CurrencyNetworkManager {
    private let networkManager: NetworkManager
    private let urlProvider: UrlProvider

    init(networkManager: NetworkManager,
         urlProvider: UrlProvider) {
        self.networkManager = networkManager
        self.urlProvider = urlProvider
    }

    func getCurrency(completion: @escaping (Result<Double, NetworkError>) -> Void) {
        guard let latestCurrencyUrl = urlProvider.getLatestCurrencyUrl() else {
            completion(.failure(.cannotGetUrl))
            return
        }
        print(latestCurrencyUrl)

        networkManager.fetchData(url: latestCurrencyUrl) { (result: Result<CurrencyLatestResult, NetworkError>) in
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
