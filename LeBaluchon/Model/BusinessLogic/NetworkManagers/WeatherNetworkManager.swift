//
//  WeatherNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class WeatherNetworkManager {
    // MARK: - INTERNAL

    typealias WeatherCompletion = (Result<[City: WeatherObject], NetworkError>) -> Void
    typealias WeatherIconCompletion = (Result<[City: Data], NetworkError>) -> Void

    // MARK: Inits

    init(networkService: NetworkService,
         weatherUrlProvider: WeatherUrlProvider) {
        self.networkService = networkService
        self.weatherUrlProvider = weatherUrlProvider
    }



    // MARK: Methods

    ///Returns by the completion parameter the WeatherObject corresponding to the given cities
    ///from the downloaded WeatherResult
    func getWeathers(forCities cities: [City], completion: @escaping WeatherCompletion) {
        let urlsResult = getUrlsForWeathers(fromCities: cities)

        switch urlsResult {
        case .failure(let networkError):
            completion(.failure(networkError))
        case .success(let urls):
            getWeatherObjects(fromUrls: urls) { result in
                switch result {
                case .failure(let networkError): completion(.failure(networkError))
                case .success(let weatherObjects): completion(.success(weatherObjects))
                }
            }
        }
    }

    ///Returns by the completion parameter the downloaded icon Data from the given dictionary of City and icon IDs
    func getWeatherIconsData(
        forCitiesAndIconIds citiesAndIconIds: [City: String],
        completion: @escaping (Result<[City: Data], NetworkError>) -> Void) {

        let urlsResult = getUrlsForWeatherIconsData(fromCitiesAndIconIds: citiesAndIconIds)

        switch urlsResult {
        case .failure(let networkError):
            completion(.failure(networkError))
        case .success(let urls):
            getIconsData(fromUrls: urls) { result in
                switch result {
                case .failure(let networkError): completion(.failure(networkError))
                case .success(let iconsData): completion(.success(iconsData))
                }
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkService: NetworkService
    private let weatherUrlProvider: WeatherUrlProvider



    // MARK: Methods

    ///Returns the URL corresponding to each given city in a dictionary of City and URL
    private func getUrlsForWeathers(fromCities cities: [City]) -> Result<[City: URL], NetworkError> {
        var urls: [City: URL] = [:]

        for city in cities {
            guard let weatherUrl = weatherUrlProvider.getWeatherUrl(city: city) else {
                return .failure(NetworkError.cannotGetUrl)
            }
            urls[city] = weatherUrl
        }
        return .success(urls)
    }

    ///Returns by the completion parameter the WeatherObject from the given URL corresponding to the given city
    ///in a dictionary of City and WeatherObject
    private func getWeatherObjects(
        fromUrls urls: [City: URL],
        completion: @escaping WeatherCompletion) {

        var weatherObjects: [City: WeatherObject] = [:]

        for (city, url) in urls {
            networkService.fetchData(url: url) {  (result: Result<WeatherResult, NetworkError>) in
                switch result {
                case .failure(let networkError):
                    completion(.failure(networkError))
                case .success(let cityResponse):
                    let weatherResult = self.createWeatherObject(fromResponse: cityResponse)

                    switch weatherResult {
                    case .failure(let networkError):
                        completion(.failure(networkError))
                    case .success(let weather):
                        weatherObjects[city] = weather
                    }

                    if weatherObjects.count == urls.count {
                        completion(.success(weatherObjects))
                    }
                }
            }
        }
    }

    ///Returns the URL corresponding to the given icon ID for each given city in a dictionary of City and URL
    private func getUrlsForWeatherIconsData(fromCitiesAndIconIds citiesAndIconIds: [City: String])
        -> Result<[City: URL], NetworkError> {

        var urls: [City: URL] = [:]

        for (city, iconId) in citiesAndIconIds {
            guard let weatherIconUrl = weatherUrlProvider.getWeatherIconUrl(iconId: iconId) else {
                return .failure(NetworkError.cannotGetUrl)
            }
            urls[city] = weatherIconUrl
        }
        return .success(urls)
    }

    ///Returns by the completion parameter the downloaded icon Data corresponding to the given URL for each given city
    ///in a dictionary of City and Data
    private func getIconsData(
        fromUrls urls: [City: URL],
        completion: @escaping WeatherIconCompletion) {

        var iconsData: [City: Data] = [:]

        for (city, url) in urls {
            networkService.fetchData(url: url) { result in
                switch result {
                case .failure(let networkError):
                    completion(.failure(networkError))
                case .success(let data):
                    iconsData[city] = data

                    if iconsData.count == urls.count {
                        completion(.success(iconsData))
                    }
                }
            }
        }
    }

    ///Returns a WeatherObject from the given WeatherResult
    private func createWeatherObject(fromResponse response: WeatherResult) -> Result<WeatherObject, NetworkError> {
        let temperature = Int(response.main.temp)
        let temperatureMin = Int(response.main.tempMin)
        let temperatureMax = Int(response.main.tempMax)
        let name = response.name

        guard let firstWeather = response.weather.first else {
            return .failure(NetworkError.cannotUnwrapFirstWeather)
        }

        let description = firstWeather.description
        let iconId = firstWeather.icon

        let weather = WeatherObject(
            temperature: temperature,
            tempMin: temperatureMin,
            tempMax: temperatureMax,
            name: name,
            description: description,
            iconId: iconId)

        return .success(weather)
    }
}
