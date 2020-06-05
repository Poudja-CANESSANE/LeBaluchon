//
//  NetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 28/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol NetworkService {
    func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
