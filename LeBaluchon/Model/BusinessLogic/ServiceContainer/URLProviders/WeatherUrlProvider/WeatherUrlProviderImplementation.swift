//
//  WeatherUrlProviderImplementation.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 04/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class WeatherUrlProviderImplementation: WeatherUrlProvider {
    ///Returns an optionnal URL to get the weather for the given City from the api.openweathermap.org API
    func getWeatherUrl(city: City) -> URL? {
        let weatherFunctionality = Functionality.weather
        guard var urlComponents = URLComponents(string: weatherFunctionality.baseUrl) else { return nil }

        weatherFunctionality.urlParameters.forEach { urlComponents.queryItems?.append(
            URLQueryItem(name: $0.key, value: $0.value)) }

        urlComponents.queryItems?.append(URLQueryItem(name: "q", value: city.name))

        return urlComponents.url
    }

    ///Returns an optionnal URL to get the icon Data for the given icon ID from the openweathermap.org API
    func getWeatherIconUrl(iconId: String) -> URL? {
        let service = Functionality.weatherIcon
        var weatherIconBaseUrl = service.baseUrl
        weatherIconBaseUrl.append("\(iconId)@2x.png")
        let weatherIconUrl = URL(string: weatherIconBaseUrl)
        return weatherIconUrl
    }
}
