//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 02/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation
import UIKit

class FakeResponseData {
    // MARK: Data

    static var currencyCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)

        guard let url = bundle.url(forResource: "Currency", withExtension: "json") else {
            fatalError("No such resource: Currency.json")
        }

        guard let currencyData = try? Data(contentsOf: url) else {
            fatalError("Failed to load Currency.json from bundle.")
        }

        return currencyData
    }

    static var translationCorrectData: Data {
        let bundle = Bundle(for: FakeResponseError.self)

        guard let url = bundle.url(forResource: "Translation", withExtension: "json") else {
            fatalError("No such resource: Translation.json")
        }

        guard let translationData = try? Data(contentsOf: url) else {
            fatalError("Failed to load Translation.json from bundle.")
        }
        return translationData
    }

    static var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseError.self)

        guard let url = bundle.url(forResource: "Weather", withExtension: "json") else {
            fatalError("No such resource: Weather.json")
        }

        guard let weatherData = try? Data(contentsOf: url) else {
            fatalError("Failed to load Weather.json from bundle.")
        }
        return weatherData
    }

    static let incorrectData = "error".data(using: .utf8)

    static let iconData = UIImage(named: "savignyLeTempleIconImage")!.pngData()

    static let incorrectIconData = UIImage(named: "incorrectIconImage")!.pngData()



    // MARK: Response

    static let responseOK = HTTPURLResponse(url: URL(
        string: "http://openclassrooms.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil)

    static let responseKO = HTTPURLResponse(url: URL(
        string: "http://openclassrooms.com")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil)




    // MARK: Error

    class FakeResponseError: Error {}
    static let error = FakeResponseError()
}
