//
//  TranslationUrlProvider.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 04/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol TranslationUrlProvider {
    func getTranslationUrl(stringToTranslate: String, targetLanguage: String) -> URL?
}
