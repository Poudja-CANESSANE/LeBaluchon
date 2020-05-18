//
//  Tanslation.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 17/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation


struct TranslationData: Decodable {
    var data: [String: Array<[String: String]>]
}

struct Translation: Decodable {
    var detectedSourceLanguage: String
    var translatedText: String
}
