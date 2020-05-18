//
//  Weather.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

struct Weathers: Codable {
    var weathers: [Weather]
}

struct Weather: Codable {
    var temperature: Int
    var main: String
    var description: String
}
