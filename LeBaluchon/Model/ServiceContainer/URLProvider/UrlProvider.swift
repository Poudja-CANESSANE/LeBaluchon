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
    func getTranslationUrl(stringToTranslate: String) -> URL?
    func getWeatherUrl(city: Cities) -> URL?
    func getUrl(service: Services, stringToTranslate: String?, city: Cities?) -> URL?
}
