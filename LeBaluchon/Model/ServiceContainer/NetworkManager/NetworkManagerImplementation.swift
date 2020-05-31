//
//  File.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class NetworkManagerImplementation: NetworkManager {
    func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
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
            
        }).resume()
    }

    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
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
            
            completion(.success(data))
        }).resume()
    }

}
