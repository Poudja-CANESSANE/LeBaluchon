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

    // MARK: Inits

    init(networkService: NetworkService,
         weatherUrlProvider: WeatherUrlProvider) {
        self.networkService = networkService
        self.weatherUrlProvider = weatherUrlProvider
    }



    // MARK: Methods

    ///Returns by the completion parameter the WeatherObject corresponding to the given cities
    ///from the downloaded WeatherResult
    func getWeathers(
        forCities cities: [City],
        completion: @escaping (Result<[City: WeatherObject], NetworkError>) -> Void) {

        let urls = getUrlsForWeathers(fromCities: cities)
        getWeatherObjects(fromUrls: urls) { result in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let weatherObjects): completion(.success(weatherObjects))
            }
        }
    }

    ///Returns by the completion parameter the downloaded icon Data from the given dictionary of City and icon IDs
    func getWeatherIconsData(
        forCitiesAndIconIds citiesAndIconIds: [City: String],
        completion: @escaping (Result<[City: Data], NetworkError>) -> Void) {

        let urls = getUrlsForWeatherIconsData(fromCitiesAndIconIds: citiesAndIconIds)
        getIconsData(fromUrls: urls) { result in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let iconsData): completion(.success(iconsData))
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkService: NetworkService
    private let weatherUrlProvider: WeatherUrlProvider



    // MARK: Methods

    ///Returns the URL corresponding to each given city in a dictionary of City and URL
    private func getUrlsForWeathers(fromCities cities: [City]) -> [City: URL] {
        var urls: [City: URL] = [:]

        for city in cities {
            if let weatherUrl = weatherUrlProvider.getWeatherUrl(city: city) {
                urls[city] = weatherUrl
            }
        }
        print("\(urls) urls " + #function)
        return urls
    }

    ///Returns by the completion parameter the WeatherObject from the given URL corresponding to the given city
    ///in a dictionary of City and WeatherObject
    private func getWeatherObjects(
        fromUrls urls: [City: URL],
        completion: @escaping (Result<[City: WeatherObject], NetworkError>) -> Void) {

        var weatherObjects: [City: WeatherObject] = [:]

        for (city, url) in urls {
            networkService.fetchData(url: url) {  (result: Result<WeatherResult, NetworkError>) in
                switch result {
                case .failure(let networkError):
                    print(networkError.message + #function)
                    completion(.failure(networkError))
                case .success(let cityResponse):
                    do {
                        weatherObjects[city] = try self.createWeatherObject(fromResponse: cityResponse)
                    } catch {
                        guard let networkError = error as? NetworkError else { return }
                        completion(.failure(networkError))
                    }

                    if weatherObjects.count == urls.count {
                        completion(.success(weatherObjects))
                    }
                }
            }
        }
    }

    ///Returns the URL corresponding to the given icon ID for each given city in a dictionary of City and URL
    private func getUrlsForWeatherIconsData(fromCitiesAndIconIds citiesAndIconIds: [City: String]) -> [City: URL] {

        var urls: [City: URL] = [:]

        for (city, iconId) in citiesAndIconIds {
            if let weatherIconUrl = weatherUrlProvider.getWeatherIconUrl(iconId: iconId) {
                urls[city] = weatherIconUrl

            }
        }

        print("\(urls) urls " + #function)
        return urls
    }

    ///Returns by the completion parameter the downloaded icon Data corresponding to the given URL for each given city
    ///in a dictionary of City and Data
    private func getIconsData(
        fromUrls urls: [City: URL],
        completion: @escaping (Result<[City: Data], NetworkError>) -> Void) {

        var iconsData: [City: Data] = [:]

        for (city, url) in urls {
            networkService.fetchData(url: url) { result in
                switch result {
                case .failure(let networkError):
                    print(networkError.message + #function)
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
    private func createWeatherObject(fromResponse response: WeatherResult) throws -> WeatherObject {
        let temperature = Int(response.main.temp)
        let temperatureMin = Int(response.main.tempMin)
        let temperatureMax = Int(response.main.tempMax)
        let name = response.name
        guard let main = response.weather.first?.main else {throw NetworkError.cannotCreateWeatherObject}
        guard let description = response.weather.first?.description else {throw NetworkError.cannotCreateWeatherObject}
        guard let iconId = response.weather.first?.icon else {throw NetworkError.cannotCreateWeatherObject}

        let weather = WeatherObject(
            temperature: temperature,
            tempMin: temperatureMin,
            tempMax: temperatureMax,
            name: name,
            main: main,
            description: description,
            iconId: iconId)

        return weather
    }
}
