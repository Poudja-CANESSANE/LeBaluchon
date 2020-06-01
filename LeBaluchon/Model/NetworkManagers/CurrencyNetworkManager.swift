//
//  CurrencuNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class CurrencyNetworkManager {
    // MARK: - INTERNAL

    // MARK: Inits

    init(networkManager: NetworkManager,
         urlProvider: UrlProvider) {
        self.networkManager = networkManager
        self.urlProvider = urlProvider
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded us rate
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



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkManager: NetworkManager
    private let urlProvider: UrlProvider
}
