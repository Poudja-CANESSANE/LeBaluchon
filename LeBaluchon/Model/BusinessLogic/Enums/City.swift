//
//  Cities.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 22/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum City: String, CaseIterable {
    case newYork
    case savignyLeTemple
    case paris
    case lille
    case marseille

    var name: String {
        switch self {
        case .newYork: return "New York"
        case .savignyLeTemple: return "Savigny-le-Temple"
        case .paris: return "Paris"
        case .lille: return "Lille"
        case .marseille: return "Arrondissement de Marseille"
        }
    }
}
