//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by Canessane Poudja on 02/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.


import Foundation

class URLSessionFake: URLSession {
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?

    init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let task = URLSessionDataTaskFake(
            completion: completionHandler,
            data: data,
            urlResponse: response,
            responseError: error)
        return task
    }
}

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
