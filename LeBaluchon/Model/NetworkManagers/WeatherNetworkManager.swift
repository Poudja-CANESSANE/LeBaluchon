//
//  WeatherNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class WeatherNetworkManager {
    func getNYCAndSLTWeathers(completion: @escaping (Result<[WeatherObject], NetworkError>) -> ()) {
        guard let nycWeatherUrl = ServiceContainer.urlProviderImplementation.getWeatherUrl(city: .newYorkCity) else {
            completion(.failure(.cannotGetUrl))
            return
        }
        print(nycWeatherUrl)

        ServiceContainer.networkManager.fetchData(url: nycWeatherUrl) { (result: Result<WeatherResult, NetworkError>) in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let nycResponse):
                self.getSLTWeather { (result) in
                    switch result {
                    case .failure(let networkError): completion(.failure(networkError))
                    case .success(let sltResponse):
                        let nycWeather = self.createWeatherObject(fromResponse: nycResponse)
                        let sltWeather = self.createWeatherObject(fromResponse: sltResponse)
                        completion(.success([nycWeather, sltWeather]))
                    }
                }
            }
        }
    }

    private func getSLTWeather(completion: @escaping (Result<WeatherResult, NetworkError>) -> ()) {
        guard let sltWeatherUrl = ServiceContainer.urlProviderImplementation.getWeatherUrl(city: .savignyLeTemple) else {
            completion(.failure(.cannotGetUrl))
            return
        }
        print(sltWeatherUrl)

        ServiceContainer.networkManager.fetchData(url: sltWeatherUrl) { (result: Result<WeatherResult, NetworkError>) in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let response): completion(.success(response))
            }
        }
    }

    private func createWeatherObject(fromResponse response: WeatherResult) -> WeatherObject{
        let temperature = Int(response.main.temp)
        let main = response.weather[0].main
        let description = response.weather[0].description
        let weather = WeatherObject(temperature: temperature, main: main, description: description)
        return weather
    }
}
