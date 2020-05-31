//
//  NetworkError.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 16/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case cannotGetUrl
    case noData
    case getError
    case noResponse
    case badStatusCode
    case cannotDecodeResponse
    case cannotUnwrapUsRate
    case cannotCreateTranslation

    var message: String {
        switch self {
        case .cannotGetUrl: return "The URL is wrong !"
        case .badStatusCode: return "The response status code is not 200 !"
        case .cannotDecodeResponse: return "The response decoding is impossible !"
        case .getError: return "There is an error while getting the response !"
        case .noData: return "There is no data !"
        case .noResponse: return "There is no response !"
        case .cannotUnwrapUsRate: return "The unwrapping of usRate is impossible !"
        case .cannotCreateTranslation: return "The creation of a translation object is impossible !"
        }
    }
}
