//
//  CurrencyUrlProviderTests.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 17/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class CurrencyUrlProviderTests: XCTestCase {
    func testGetLatestCurrencyUrl() {
        let currencyUrlProvider = CurrencyUrlProviderImplementation()
        let currencyUrl = currencyUrlProvider.getLatestCurrencyUrl()!
        XCTAssertEqual(currencyUrl.absoluteString,
                       "http://data.fixer.io/api/latest?access_key=1ad582ca1c36a3ebd81816f01af88fb7")
    }
}
