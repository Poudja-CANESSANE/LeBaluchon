//
//  WeatherNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class WeatherNetworkManager {
    static let shared = WeatherNetworkManager()
    private init() {}

    private static let nycWeatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=New%20York%20City&appid=d62aa4043ab2eee875bd047c423b9962&units=metric")!
    private static let sltWeatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Savigny-le-Temple&appid=d62aa4043ab2eee875bd047c423b9962&units=metric")!

    private var task: URLSessionTask?

    func getNYCAndSLTWeathers(callback: @escaping (Result<Weathers?, NetworkError>) -> ()) {
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: WeatherNetworkManager.nycWeatherUrl , completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    callback(.failure(.noData))
                    return
                }
                guard error == nil else {
                    callback(.failure(.getError))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    callback(.failure(.noResponse))
                    return
                }
                guard response.statusCode == 200 else {
                    callback(.failure(.badStatusCode))
                    return
                }
                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                    callback(.failure(.cannotDecodeResponse))
                    return
                }

                self.getSLTWeather { (result) in
                    switch result {
                    case.failure(let networkError):
                        callback(.failure(networkError))
                    case .success(let weather):
                        guard let sltWeather = weather else {return}
                        guard let nycWeather = self.createWeatherFrom(data: responseJSON) else {return}
                        let weathers = Weathers(weathers: [nycWeather, sltWeather])
                        callback(.success(weathers))
                    }
                }
            }
        })
        task?.resume()
    }

    private func getSLTWeather(callback: @escaping (Result<Weather?, NetworkError>) -> ()) {
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: WeatherNetworkManager.sltWeatherUrl , completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    callback(.failure(.noData))
                    return
                }
                guard error == nil else {
                    callback(.failure(.getError))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    callback(.failure(.noResponse))
                    return
                }
                guard response.statusCode == 200 else {
                    callback(.failure(.badStatusCode))
                    return
                }
                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                    callback(.failure(.cannotDecodeResponse))
                    return
                }

                let sltWeather = self.createWeatherFrom(data: responseJSON)
                callback(.success(sltWeather))
            }
        })
        task?.resume()
    }

    private func createWeatherFrom(data: [String: Any]) -> Weather? {
        guard let weatherData = data["weather"] as? Array<[String: Any]> else { return nil }

        guard let main = weatherData[0]["main"] as? String else { return nil }

        guard let weatherIcon = WeatherIcon.weatherIcons[main] else { return nil }

        guard let description = weatherData[0]["description"] as? String else { return nil }

        guard let mainData = data["main"] as? [String: Any] else { return nil }
        
        guard let temp = mainData["temp"] as? Double else { return nil }

        let weather = Weather(temperature: Int(temp), main: weatherIcon, description: description)
        return weather
    }
}
