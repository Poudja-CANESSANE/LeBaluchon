//
//  TranslationUrlProviderTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 17/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class TranslationUrlProviderTests: XCTestCase {
    func testGetTanslationUrl() {
        let translationUrlProvider = TranslationUrlProviderImplementation()
        let translationUrl = translationUrlProvider.getTranslationUrl(
            stringToTranslate: "Bonjour", targetLanguage: "en")!
        XCTAssertEqual(translationUrl.absoluteString,
                       "https://translation.googleapis.com/language/translate/v2?key=AIzaSyC_XVOjoWJ-R3tDwy8VHBQitgEKJdMhQCY&q=Bonjour&target=en") //swiftlint:disable:this line_length
    }

}
