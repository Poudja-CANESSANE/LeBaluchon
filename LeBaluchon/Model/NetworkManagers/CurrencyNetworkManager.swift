//
//  CurrencuNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class CurrencyNetworkManager {
    static let shared = CurrencyNetworkManager()
    private init() {}

    private static let currencyUrl = URL(string: "http://data.fixer.io/api/latest?access_key=1ad582ca1c36a3ebd81816f01af88fb7")!
    private var task: URLSessionTask?

    func getCurrency(completion: @escaping (Result<Float, NetworkError>) -> Void) {
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: CurrencyNetworkManager.currencyUrl, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure(.getError))
                    return
                }
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.noResponse))
                    return
                }

                guard response.statusCode == 200 else {
                    completion(.failure(.badStatusCode))
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode([String: [String: Float]].self, from: data) else {
                    completion(.failure(.cannotDecodeResponse))
                    return
                }

                guard let rates = responseJSON["rates"] else {
                    completion(.failure(.getError))
                    return
                }

                guard let usRate = rates["USD"] else {
                    completion(.failure(.getError))
                    return
                }

                completion(.success(usRate))
            }
        })
        task?.resume()
    }
}
