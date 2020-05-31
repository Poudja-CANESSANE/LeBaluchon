//
//  WeatherNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class WeatherNetworkManager {
    private let networkManager: NetworkManager
    private let urlProvider: UrlProvider

    init(networkManager: NetworkManager,
         urlProvider: UrlProvider) {
        self.networkManager = networkManager
        self.urlProvider = urlProvider
    }

    func getWeathers(forCities cities: [City], completion: @escaping (Result<[City: WeatherObject], NetworkError>) -> ()) {
        let urls = getUrlsForWeathers(fromCities: cities)
        getWeatherObjects(fromUrls: urls) { result in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let weatherObjects): completion(.success(weatherObjects))
            }
        }
    }

    func getWeatherIconsData(forCitiesAndIconIds citiesAndIconIds: [City: String], completion: @escaping (Result<[City: Data], NetworkError>) -> ()) {
        let urls = getUrlsForWeatherIconsData(fromCitiesAndIconIds: citiesAndIconIds)
        getIconsData(fromUrls: urls) { result in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let iconsData): completion(.success(iconsData))
            }
        }
    }

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

    private func getWeatherObjects(fromUrls urls: [City: URL], completion: @escaping (Result<[City: WeatherObject], NetworkError>) -> ()) {
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

    private func getIconsData(fromUrls urls: [City: URL], completion: @escaping (Result<[City: Data], NetworkError>) -> ()) {
        var iconsData: [City: Data] = [:]

        for (city, url) in urls {
            networkManager.fetchData(url: url) { (result) in
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

    func getWeatherIconDataForWeatherViewController(iconId: String, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        guard let weatherIconUrl = urlProvider.getWeatherIconUrl(iconId: iconId) else {
            completion(.failure(.cannotGetUrl))
            return
        }

        networkManager.fetchData(url: weatherIconUrl) { (result) in
            switch result {
            case .failure(let networkError):
                print(networkError.message + #function)
                completion(.failure(networkError))
            case .success(let data):
                completion(.success(data))
            }
        }
    }
    
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

        private func getUrls(fromCities cities: [City]? = nil, fromCitiesAndIconIds citiesAndIconIds: [City: String]? = nil) -> [City: URL] {
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

            print("\(urls) urls " + #function)
            return urls
        }
}
