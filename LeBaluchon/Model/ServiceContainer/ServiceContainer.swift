//
//  ServiceContainer.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 22/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class ServiceContainer {
    static let urlProvider: UrlProvider = UrlProviderImplementation()
    static let networkManager: NetworkManager = NetworkManagerImplementation()
    static let alertManager = AlertManager()
}
