//swiftlint:disable force_try
//  TranslationTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 10/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class TranslationTests: XCTestCase {
    func testGetTranslationShouldFailIfError() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfNoData() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: nil, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfNoResponse() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: FakeResponseData.translationCorrectData, response: nil, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfIncorrectData() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfIncorrectResponse() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseKO, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfIncorrectUrl() {
        let translationNetworkManager = getTranslationNetworkManagerWithStubUrlProvider()

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotGetUrl)
            } else { XCTFail() }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldFailIfIncorrectTranslationData() {
        let translationNetworkManager = getTranslationNetworkManager(
            data: FakeResponseData.translationIncorrectData, response: FakeResponseData.responseOK, error: nil)

        let expectation = XCTestExpectation(description: "Wait")
        translationNetworkManager.getTranslation(forTextToTranslate: "Bonjour", inTargetLanguage: "en") { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotCreateTranslation)
            } else { XCTFail() }
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
                let translation = try! result.get()
                XCTAssertEqual(translation.translatedText, translatedText)
                XCTAssertEqual(translation.detectedSourceLanguage, detectedSourceLanguage)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }



    // MARK: Tools

    private func getTranslationNetworkManager(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> TranslationNetworkManager {

        let sessionFake = URLSessionFake(data: data, response: response, error: error)

        let translationNetworkManager = TranslationNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            translationUrlProvider: TranslationUrlProviderImplementation())

        return translationNetworkManager
    }

    private func getTranslationNetworkManagerWithStubUrlProvider() -> TranslationNetworkManager {
        let sessionFake = URLSessionFake(data: nil, response: nil, error: nil)

        let translationNetworkManager = TranslationNetworkManager(
            networkService: NetworkServiceImplementation(session: sessionFake),
            translationUrlProvider: TranslationUrlProviderStub())

        return translationNetworkManager
    }
}
