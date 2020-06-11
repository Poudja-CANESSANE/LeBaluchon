//swiftlint:disable force_try
//  WeatherTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 10/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class WeatherTests: XCTestCase {
    // MARK: Test getWeathers()

    func testGetWeathersShouldFailIfError() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfNoData() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfNoResponse() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.weatherCorrectData, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfIncorrectData() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfIncorrectResponse() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfIncorrectUrl() {
        let weatherNetworkManager = getWeatherNetworkManagerWithStubUrlProvider()

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotGetUrl)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfIncorrectWeatherData() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.weatherIncorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotCreateWeatherObject)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldSucceedIfNoErrorAndCorrectResponseAndCorrectData() {
        let correctWeather = WeatherObject(
            temperature: 28,
            tempMin: 27,
            tempMax: 29,
            name: "Savigny-le-Temple",
            main: "Clouds",
            description: "few clouds",
            iconId: "02d")

        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            let weathers = try! result.get()
            XCTAssertEqual(weathers[.savignyLeTemple], correctWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: Test getWeatherIcon()

    func testGetWeatherIconShouldFailIfError() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in

            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfNoData() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfNoResponse() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.iconData, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfIncorrectIconData() {
        let correctIconData = UIImage(named: "savignyLeTempleIconImage")!.pngData()

        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.incorrectIconData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            let iconsData = try! result.get()
            XCTAssertNotEqual(iconsData[.savignyLeTemple], correctIconData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfIncorrectResponse() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.iconData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfIncorrectUrl() {
        let weatherNetworkManager = getWeatherNetworkManagerWithStubUrlProvider()

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotGetUrl)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldSucceedfNoErrorAndCorrectResponseAndCorrectData() {
        let iconImage = UIImage(named: "savignyLeTempleIconImage")!.pngData()

        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.iconData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in

            let iconsData = try! result.get()
            XCTAssertEqual(iconsData[.savignyLeTemple], iconImage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: Tools

    private func getWeatherNetworkManager(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> WeatherNetworkManager {

        let sessionFake = URLSessionFake(data: data, response: response, error: error)

        let weatherNetworkManager = WeatherNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            weatherUrlProvider: WeatherUrlProviderImplementation())

        return weatherNetworkManager
    }

    private func getWeatherNetworkManagerWithStubUrlProvider() -> WeatherNetworkManager {
        let sessionFake = URLSessionFake(data: nil, response: nil, error: nil)

        let weatherNetworkManager = WeatherNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            weatherUrlProvider: WeatherUrlProviderStub())

        return weatherNetworkManager
    }
}
