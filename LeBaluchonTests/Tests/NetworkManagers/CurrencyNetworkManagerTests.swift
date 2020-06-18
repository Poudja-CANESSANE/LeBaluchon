//swiftlint:disable force_try
//  CurrencyTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 10/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class CurrencyNetworkManagerTests: XCTestCase {
    func testGetLatestUSDCurrencyRateShouldFailIfError() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfNoData() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfNoResponse() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: FakeResponseData.currencyCorrectData, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfIncorrectData() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfIncorrectResponse() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfIncorrectUrl() {
        let currencyNetworkManager = getCurrencyNetworkManagerWithStubUrlProvider()

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotGetUrl)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetLatestUSDCurrencyRateShouldFailIfIncorrectCurrencyData() {
        let currencyNetworkManager = getCurrencyNetworkManager(
            data: FakeResponseData.currencyIncorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        currencyNetworkManager.getLatestUSDCurrencyRate { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotUnwrapUsRate)
            } else { XCTFail() }
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
            let downloadedUSRate = try! result.get()
            XCTAssertEqual(downloadedUSRate, usRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: Tools

    ///Returns a CurrencyNetworkManager with a URLSessionFake from the given Data?, HTTPURLResponse? and Error?
    private func getCurrencyNetworkManager(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> CurrencyNetworkManager {

        let sessionFake = URLSessionFake(data: data, response: response, error: error)

        let currencyNetworkManager = CurrencyNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            currencyUrlProvider: CurrencyUrlProviderImplementation())

        return currencyNetworkManager
    }

    ///Returns a CurrencyNetworkManager with a URLSessionFake and a CurrencyUrlProviderStub
    private func getCurrencyNetworkManagerWithStubUrlProvider() -> CurrencyNetworkManager {
        let sessionFake = URLSessionFake(data: nil, response: nil, error: nil)

        let currencyNetworkManager = CurrencyNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            currencyUrlProvider: CurrencyUrlProviderStub())

        return currencyNetworkManager
    }
}
