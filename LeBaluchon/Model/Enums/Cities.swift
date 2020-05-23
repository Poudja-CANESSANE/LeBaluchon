//
//  Cities.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 22/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum Cities: String {
    case newYorkCity
    case savignyLeTemple

    var name: String {
        switch self {
        case .newYorkCity: return "New York City"
        case .savignyLeTemple: return "Savigny-le-temple"
        }
    }
}
