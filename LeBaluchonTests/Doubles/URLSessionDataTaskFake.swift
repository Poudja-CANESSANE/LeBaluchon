//
//  URLSessionDataTaskFake.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 17/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class URLSessionDataTaskFake: URLSessionDataTask {
    var completion: ((Data?, HTTPURLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: HTTPURLResponse?
    var responseError: Error?

    init(completion: ((Data?, HTTPURLResponse?, Error?) -> Void)?,
         data: Data?, urlResponse: HTTPURLResponse?, responseError: Error?) {
        self.completion = completion
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }

    override func resume() {
        completion?(data, urlResponse, responseError)
    }
}
