//
//  Services.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 22/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum Services {
    case currency, translation, weather

    var baseUrl: String {
        switch self {
        case .currency: return "http://data.fixer.io/api/latest?"
        case .translation: return "https://translation.googleapis.com/language/translate/v2?"
        case .weather: return "http://api.openweathermap.org/data/2.5/weather?"
        }
    }

    var urlParameters: [String: String] {
        switch self {
        case .currency:
            return ["access_key": "1ad582ca1c36a3ebd81816f01af88fb7"]
        case .translation:
            return ["key": "AIzaSyC_XVOjoWJ-R3tDwy8VHBQitgEKJdMhQCY", "target": "en"]
        case .weather:
            return ["appid": "d62aa4043ab2eee875bd047c423b9962", "units": "metric"]
        }
    }
}
