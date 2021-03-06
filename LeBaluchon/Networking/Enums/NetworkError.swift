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
    case cannotDecodeData
    case cannotUnwrapUsRate
    case cannotUnwrapFirstTranslation
    case cannotUnwrapFirstWeather

    var message: String {
        switch self {
        case .cannotGetUrl: return "The URL is wrong !"
        case .badStatusCode: return "The response status code is not 200 !"
        case .cannotDecodeData: return "The data decoding is impossible !"
        case .getError: return "An error occurred while getting the response !"
        case .noData: return "There is no data !"
        case .noResponse: return "There is no response !"
        case .cannotUnwrapUsRate: return "The unwrapping of usRate is impossible !"
        case .cannotUnwrapFirstTranslation: return "The unwrapping of the first Translation is impossible !"
        case .cannotUnwrapFirstWeather: return "The unwrapping of the first WeatherObject is impossible !"
        }
    }
}
