//swiftlint:disable line_length
//  WeatherUrlProviderTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 17/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class WeatherUrlProviderTests: XCTestCase {
    let weatherUrlProvider = WeatherUrlProviderImplementation()
    func testGetWeatherUrl() {
        let weatherUrl = weatherUrlProvider.getWeatherUrl(city: City.savignyLeTemple)!

        let weatherUrlIsCorrect = weatherUrl.absoluteString == "http://api.openweathermap.org/data/2.5/weather?appid=d62aa4043ab2eee875bd047c423b9962&units=metric&q=Savigny-le-Temple"
            || weatherUrl.absoluteString == "http://api.openweathermap.org/data/2.5/weather?units=metric&appid=d62aa4043ab2eee875bd047c423b9962&q=Savigny-le-Temple"

        XCTAssertTrue(weatherUrlIsCorrect)
    }

    func testGetWeatherIconUrl() {
        let weatherIconUrl = weatherUrlProvider.getWeatherIconUrl(iconId: "02d")
        XCTAssertEqual(weatherIconUrl?.absoluteString, "http://openweathermap.org/img/wn/02d@2x.png")
    }
}
