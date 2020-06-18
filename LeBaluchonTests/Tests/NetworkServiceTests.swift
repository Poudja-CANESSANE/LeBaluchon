//swiftlint:disable force_try
//  NetworkServiceTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 16/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class NetworkServiceTests: XCTestCase {
    let url = URL(string: "http://openclassrooms.com")!

    // MARK: Test fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)

    func testFetchDataShouldFailIfError() {
        let networkService = getNetworkService(data: nil, response: nil, error: FakeResponseData.error)
        networkService.fetchData(url: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
        }
    }

    func testFetchDataShouldFailIfNoData() {
        let networkService = getNetworkService(data: nil, response: nil, error: nil)
        networkService.fetchData(url: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
        }
    }

    func testFetchDataShouldFailIfNoResponse() {
        let networkService = getNetworkService(data: FakeResponseData.iconData, response: nil, error: nil)
        networkService.fetchData(url: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            }
        }
    }

    func testFetchDataShouldFailIfIncorrectResponse() {
        let networkService = getNetworkService(
            data: FakeResponseData.iconData, response: FakeResponseData.responseKO, error: nil)
        networkService.fetchData(url: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
        }
    }

    func testFetchDataShouldSucceedIfNoErrorAndCorrectResponseAndCorrectData() {
        let networkService = getNetworkService(
            data: FakeResponseData.iconData, response: FakeResponseData.responseOK, error: nil)
        networkService.fetchData(url: url) { result in
            let data = try! result.get()
            XCTAssertEqual(data, FakeResponseData.iconData)
        }
    }



    // MARK: Test fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)

    func testFetchDataGenericVersionShouldFailIfError() {
        let networkService = getNetworkService(data: nil, response: nil, error: FakeResponseData.error)
        networkService.fetchData(url: url) { (result: Result<CurrencyLatestResult, NetworkError>) in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
        }
    }

    func testFetchDataGenericVersionShouldFailIfNoData() {
        let networkService = getNetworkService(data: nil, response: nil, error: nil)
        networkService.fetchData(url: url) { (result: Result<CurrencyLatestResult, NetworkError>) in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
        }
    }

    func testFetchDataGenericVersionShouldFailIfNoResponse() {
        let networkService = getNetworkService(data: FakeResponseData.currencyCorrectData, response: nil, error: nil)
        networkService.fetchData(url: url) { (result: Result<CurrencyLatestResult, NetworkError>) in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
        }
    }

    func testFetchDataGenericVersionShouldFailIfIncorrectResponse() {
        let networkService = getNetworkService(
            data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseKO, error: nil)
        networkService.fetchData(url: url) { (result: Result<CurrencyLatestResult, NetworkError>) in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
        }
    }

    func testFetchDataGenericVersionShouldFailIfIncorrectData() {
        let networkService = getNetworkService(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        networkService.fetchData(url: url) { (result: Result<CurrencyLatestResult, NetworkError>) in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            } else { XCTFail() }
        }
    }

    func testFetchDataGenericVersionShouldFailIfNoErrorAndCorrectResponseAndCorrectData() {
        let networkService = getNetworkService(
            data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseOK, error: nil)
        networkService.fetchData(url: url) { (result: Result<CurrencyLatestResult, NetworkError>) in
            if case .success(let currencyResult) = result {
                let downloadedUSRate = currencyResult.rates["USD"]!
                XCTAssertEqual(downloadedUSRate, 1.118218)
            } else { XCTFail() }
        }
    }

    // MARK: Tools

    private func getNetworkService(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> NetworkServiceImplementation {

        let sessionFake = URLSessionFake(data: data, response: response, error: error)
        let networkService = NetworkServiceImplementation(session: sessionFake)
        return networkService
    }
}
