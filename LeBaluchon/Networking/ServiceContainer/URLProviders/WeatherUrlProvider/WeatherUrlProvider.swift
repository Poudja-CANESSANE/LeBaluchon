//
//  WeatherUrlProvider.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 04/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol WeatherUrlProvider {
    func getWeatherUrl(city: City) -> URL?
    func getWeatherIconUrl(iconId: String) -> URL?
}
