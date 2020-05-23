//
//  Weather.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

struct WeatherObject {
    let temperature: Int
    let main, description: String
}

struct WeatherResult: Codable {
    let weather: [Weather]
    let main: Main
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let main, description: String
}
