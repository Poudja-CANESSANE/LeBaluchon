//
//  Tanslation.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 17/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

struct TranslationResult: Codable {
    let data: TranslationData
}

struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}
