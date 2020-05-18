//
//  NetworkError.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 16/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noData
    case getError
    case noResponse
    case badStatusCode
    case cannotDecodeResponse

    var message: String {
        switch self {
        case .badStatusCode: return "The response status code is not 200 !"
        case .cannotDecodeResponse: return "The response decoding eis impossible !"
        case .getError: return "There is an error while getting the response !"
        case .noData: return "There is no data !"
        case .noResponse: return "There is no response !"
        }
    }
}
