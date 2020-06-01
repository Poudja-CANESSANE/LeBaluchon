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

    init(networkManager: NetworkManager,
         urlProvider: UrlProvider) {
        self.networkManager = networkManager
        self.urlProvider = urlProvider
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

    ///Returns by the completion parameter the downloaded icon Data from the given icon ID
    func getWeatherIconDataForWeatherViewController(
        iconId: String,
        completion: @escaping (Result<Data, NetworkError>) -> Void) {

        guard let weatherIconUrl = urlProvider.getWeatherIconUrl(iconId: iconId) else {
            completion(.failure(.cannotGetUrl))
            return
        }

        networkManager.fetchData(url: weatherIconUrl) { result in
            switch result {
            case .failure(let networkError):
                print(networkError.message + #function)
                completion(.failure(networkError))
            case .success(let data):
                completion(.success(data))
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkManager: NetworkManager
    private let urlProvider: UrlProvider



    // MARK: Methods

    ///Returns the URL corresponding to each given city in a dictionary of City and URL
    private func getUrlsForWeathers(fromCities cities: [City]) -> [City: URL] {
        var urls: [City: URL] = [:]

        for city in cities {
            if let weatherUrl = urlProvider.getWeatherUrl(city: city) {
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
            networkManager.fetchData(url: url) {  (result: Result<WeatherResult, NetworkError>) in
                switch result {
                case .failure(let networkError):
                    print(networkError.message + #function)
                    completion(.failure(networkError))
                case .success(let cityResponse):
                    weatherObjects[city] = self.createWeatherObject(fromResponse: cityResponse)

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
            if let weatherIconUrl = urlProvider.getWeatherIconUrl(iconId: iconId) {
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
            networkManager.fetchData(url: url) { result in
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
    private func createWeatherObject(fromResponse response: WeatherResult) -> WeatherObject {
        let temperature = Int(response.main.temp)
        let temperatureMin = Int(response.main.tempMin)
        let temperatureMax = Int(response.main.tempMax)
        let name = response.name
        let main = response.weather[0].main
        let description = response.weather[0].description
        let iconId = response.weather[0].icon

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

    private func getUrls(
        fromCities cities: [City]? = nil,
        fromCitiesAndIconIds citiesAndIconIds: [City: String]? = nil) -> [City: URL] {
        var urls: [City: URL] = [:]

        if let cities = cities {
            for city in cities {
                if let weatherUrl = urlProvider.getWeatherUrl(city: city) {
                    urls[city] = weatherUrl
                }
            }
        }

        if let citiesAndIconIds = citiesAndIconIds {
            for (city, iconId) in citiesAndIconIds {
                if let weatherIconUrl = urlProvider.getWeatherIconUrl(iconId: iconId) {
                    urls[city] = weatherIconUrl

                }
            }
        }

        print("\(urls) urls " + #function)
        return urls

//        if sequence.self == [City].self {
//            for city in sequence.enumerated() {
//                if let weatherUrl = urlProviderImplementation.getWeatherIconUrl(icon: iconId) {
//                    urls[city] = weatherUrl
//
//                }
//            }
//        }
//        if sequence.self == [City: String].self {
//            var city: City
//            var iconId: String
//            for (city, iconId) in sequence.enumerated() {
//                if let weatherIconUrl = urlProviderImplementation.getWeatherIconUrl(icon: iconId as! String) {
//                    urls[city] = weatherIconUrl
//
//                }
//            }
//        }
    }
}
