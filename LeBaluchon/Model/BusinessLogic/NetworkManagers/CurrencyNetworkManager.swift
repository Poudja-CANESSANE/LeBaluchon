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

    init(networkService: NetworkService,
         currencyUrlProvider: CurrencyUrlProvider) {
        self.networkService = networkService
        self.currencyUrlProvider = currencyUrlProvider
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded us rate
    func getLatestUSDCurrencyRate(completion: @escaping (Result<Double, NetworkError>) -> Void) {
        guard let latestCurrencyUrl = currencyUrlProvider.getLatestCurrencyUrl() else {
            completion(.failure(.cannotGetUrl))
            return
        }

        networkService.fetchData(url: latestCurrencyUrl) { (result: Result<CurrencyLatestResult, NetworkError>) in
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

    private let networkService: NetworkService
    private let currencyUrlProvider: CurrencyUrlProvider
}
