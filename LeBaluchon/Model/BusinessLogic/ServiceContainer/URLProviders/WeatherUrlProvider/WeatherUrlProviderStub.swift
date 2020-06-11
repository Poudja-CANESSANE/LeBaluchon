//
//  WeatherUrlProviderStub.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 10/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class WeatherUrlProviderStub: WeatherUrlProvider {
    func getWeatherUrl(city: City) -> URL? {
        return nil
    }

    func getWeatherIconUrl(iconId: String) -> URL? {
        return nil
    }
}
