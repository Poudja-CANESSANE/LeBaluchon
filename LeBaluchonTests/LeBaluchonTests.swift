//swiftlint:disable type_body_length file_length
//  LeBaluchonTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 12/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class LeBaluchonTests: XCTestCase {
    // MARK: Test CurrencyNetworkManager

    func testGetLatestUSDCurrencyRateShouldFailIfError() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.getError)
            case .success(let usRate):
                XCTAssertNil(usRate)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfNoData() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.noData)
            case .success(let usRate):
                XCTAssertNil(usRate)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfIncorrectData() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            case .success(let usRate):
                XCTAssertNil(usRate)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfIncorrectResponse() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            case .success(let usRate):
                XCTAssertNil(usRate)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldSucceedIfNoErrorAndCorrectResponseAndCorrectData() {
        let usRate = 1.118218

        let currencyNetworkManager = getCurrencyNetworkManager(
            data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            switch result {
            case .failure(let networkError):
                XCTAssertNil(networkError)
            case .success(let downloadedUSRate):
                XCTAssertEqual(downloadedUSRate, usRate)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: Test TranslationNetworkManager

    func testGetTranslationShouldFailIfError() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.getError)
            case .success(let translation):
                XCTAssertNil(translation)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfNoData() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.noData)
            case .success(let translation):
                XCTAssertNil(translation)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfIncorrectData() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            case .success(let translation):
                XCTAssertNil(translation)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfIncorrectResponse() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            case .success(let translation):
                XCTAssertNil(translation)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldSucceedIfNoErrorAndCorrectResponseAndCorrectData() {
        let translatedText = "Jean says: \"I like apples and pasta!\"."
        let detectedSourceLanguage = "fr"

        let translationNetworkManager = getTranslationNetworkManager(
            data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(
            forTextToTranslate: "Jean dit: \"J'aime les pommes et les pâtes !\".",
            inTargetLanguage: "en") { result in
                switch result {
                case .failure(let networkError):
                    XCTAssertNil(networkError)
                case .success(let translation):
                    XCTAssertEqual(translation.translatedText, translatedText)
                    XCTAssertEqual(translation.detectedSourceLanguage, detectedSourceLanguage)
                }
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: TestWeatherNetworkManager

    // MARK: getWeathers

    func testGetWeathersShouldFailIfError() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.getError)
            case .success(let weathers):
                XCTAssertNil(weathers)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfNoData() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.noData)
            case .success(let weathers):
                XCTAssertNil(weathers)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfIncorrectData() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            case .success(let weathers):
                XCTAssertNil(weathers)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldFailIfIncorrectResponse() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            case .success(let weathers):
                XCTAssertNil(weathers)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeathersShouldSucceedIfNoErrorAndCorrectResponseAndCorrectData() {
        let temperature = 28
        let tempMin = 27
        let tempMax = 29
        let name = "Savigny-le-Temple"
        let main = "Clouds"
        let description = "few clouds"
        let iconId = "02d"

        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeathers(forCities: [City.savignyLeTemple]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertNil(networkError)
            case .success(let weathers):
                XCTAssertEqual(weathers[.savignyLeTemple]?.temperature, temperature)
                XCTAssertEqual(weathers[.savignyLeTemple]?.tempMin, tempMin)
                XCTAssertEqual(weathers[.savignyLeTemple]?.tempMax, tempMax)
                XCTAssertEqual(weathers[.savignyLeTemple]?.name, name)
                XCTAssertEqual(weathers[.savignyLeTemple]?.main, main)
                XCTAssertEqual(weathers[.savignyLeTemple]?.description, description)
                XCTAssertEqual(weathers[.savignyLeTemple]?.iconId, iconId)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: getWeatherIcon

    func testGetWeatherIconShouldFailIfError() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.getError)
            case .success(let iconsData):
                XCTAssertNil(iconsData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfNoData() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.noData)
            case .success(let iconsData):
                XCTAssertNil(iconsData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfIncorrectData() {
        let correctIconData = UIImage(named: "savignyLeTempleIconImage")!.pngData()

        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            case .success(let iconsData):
                XCTAssertNotEqual(iconsData[.savignyLeTemple], correctIconData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherIconShouldFailIfIncorrectResponse() {
        let weatherNetworkManager = getWeatherNetworkManager(
            data: FakeResponseData.iconData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: [.savignyLeTemple: "02d"]) { result in
            switch result {
            case .failure(let networkError):
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            case .success(let iconsData):
                XCTAssertNil(iconsData)
            }
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
            switch result {
            case .failure(let networkError):
                XCTAssertNil(networkError)
            case .success(let iconsData):
                XCTAssertEqual(iconsData[.savignyLeTemple], iconImage)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: Tools

    func getCurrencyNetworkManager(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> CurrencyNetworkManager {

        let sessionFake = URLSessionFake(data: data, response: response, error: error)

        let currencyNetworkManager = CurrencyNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            currencyUrlProvider: CurrencyUrlProviderImplementation())

        return currencyNetworkManager
    }

    func getTranslationNetworkManager(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> TranslationNetworkManager {

        let sessionFake = URLSessionFake(data: data, response: response, error: error)

        let translationNetworkManager = TranslationNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            translationUrlProvider: TranslationUrlProviderImplementation())

        return translationNetworkManager
    }

    func getWeatherNetworkManager(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> WeatherNetworkManager {

        let sessionFake = URLSessionFake(data: data, response: response, error: error)

        let weatherNetworkManager = WeatherNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            weatherUrlProvider: WeatherUrlProviderImplementation())

        return weatherNetworkManager
    }
}
