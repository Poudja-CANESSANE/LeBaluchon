//
//  File.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class NetworkManager {
    func fetchData<T: Decodable>(urlString: String, textToTranslate: String = "", completion: @escaping (Result<T?, NetworkError>) -> ()) {
        guard let url = URL(string: urlString + textToTranslate) else {
            completion(.failure(.getError))
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
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

                guard let responseJSON = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(.failure(.cannotDecodeResponse))
                    return
                }

                completion(.success(responseJSON))
            }
        }).resume()
    }
}
