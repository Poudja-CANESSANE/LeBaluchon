//
//  Weather.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

struct WeatherObject {
    let temperature, tempMin, tempMax: Int
    let main, description: String
}

struct WeatherResult: Codable {
    let weather: [Weather]
    let main: Main
}

struct Main: Codable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let main, description: String
}
