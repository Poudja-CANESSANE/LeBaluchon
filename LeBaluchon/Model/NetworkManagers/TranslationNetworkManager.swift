//
//  TranslateNetworkManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 13/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class TranslationNetworkManager {
    static let shared = TranslationNetworkManager()
    private init() {}

    private var task: URLSessionDataTask?


    private var stringToTranslate: String = "Hello" {
        didSet {
            stringToTranslate = stringToTranslate.replacingOccurrences(of: " ", with: "%20")
            stringToTranslate = stringToTranslate.replacingOccurrences(of: "’", with: "%27")
            print(stringToTranslate)
        }
    }
    private static var url = "https://translation.googleapis.com/language/translate/v2?target=en&key=AIzaSyC_XVOjoWJ-R3tDwy8VHBQitgEKJdMhQCY&q="

    func translate(textToTranslate: String, completion: @escaping (Result<Translation?, NetworkError>) -> ()) {
        stringToTranslate = textToTranslate
        print(stringToTranslate)
        guard let url = URL(string: TranslationNetworkManager.url + stringToTranslate) else {
            completion(.failure(.getError))
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure(.getError))
                    return
                }
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.noResponse))
                    return
                }

                guard response.statusCode == 200 else {
                    completion(.failure(.badStatusCode))
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode(TranslationData.self, from: data) else {
                    completion(.failure(.cannotDecodeResponse))
                    return
                }

                let translation = self.createTranslationFrom(response: responseJSON)
                completion(.success(translation))
            }
        }).resume()
    }

    private func createTranslationFrom(response: TranslationData) -> Translation? {
        let translationData = response.data

        guard let translations = translationData["translations"] else {return nil}

        guard let detectedSourceLanguage = translations[0]["detectedSourceLanguage"] else {return nil}

        guard let translatedText = translations[0]["translatedText"] else {return nil}

        let translation = Translation(detectedSourceLanguage: detectedSourceLanguage, translatedText: translatedText)
        return translation
    }
    
}
