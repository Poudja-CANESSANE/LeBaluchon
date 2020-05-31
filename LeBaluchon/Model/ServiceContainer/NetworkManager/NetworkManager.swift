//
//  NetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 28/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol NetworkManager {
    func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> ())
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> ())
}
