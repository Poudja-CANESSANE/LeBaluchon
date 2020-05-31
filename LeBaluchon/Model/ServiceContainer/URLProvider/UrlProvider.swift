//
//  UrlProvider.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 22/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol UrlProvider {
    func getLatestCurrencyUrl() -> URL?
    func getTranslationUrl(stringToTranslate: String, targetLanguage: String) -> URL?
    func getWeatherUrl(city: City) -> URL?
    func getWeatherIconUrl(iconId: String) -> URL?
}
