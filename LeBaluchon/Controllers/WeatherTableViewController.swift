//swiftlint:disable weak_delegate
//  WeatherTableViewViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 29/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherTableViewController: UIViewController {
    // MARK: - INTERNAL

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!

    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateUIWithDownloadedWeathers), for: .valueChanged)
        return refreshControl
    }()


    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUIWithDownloadedWeathers()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let weatherNetworkManager = WeatherNetworkManager(
            networkService: ServiceContainer.networkService,
            weatherUrlProvider: ServiceContainer.weatherUrlProvider)

    private let alertManager = ServiceContainer.alertManager
    private let weatherTableViewDataSource = WeatherTableViewDataSource()
    private let weatherTableViewDelegate = WeatherTableViewDelegate()



    // MARK: Methods

    ///Sets the dataSource, the delegate and the refreshControl properties of the tableView
    private func setupTableView() {
        tableView.dataSource = weatherTableViewDataSource
        tableView.delegate = weatherTableViewDelegate
        tableView.refreshControl = refresher
    }

    ///Updates the UI with the downloaded weathers
    @objc private func updateUIWithDownloadedWeathers() {
        let cities = getCities()

        weatherNetworkManager.getWeathers(forCities: cities) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message + #function)
                case .success(let downloadedWeathers):
                    self.weatherTableViewDataSource.populateProperties(withDownloadedWeathers: downloadedWeathers)
                    self.assignValueToIconsData(fromIconsId: self.weatherTableViewDataSource.iconsId)
                }
            }
        }
    }

    ///Returns an array containing all City cases
    private func getCities() -> [City] {
        var cities: [City] = []
        City.allCases.forEach { cities.append($0)}
        return cities
    }

    ///Assigns a value to weatherTableViewDataSource's iconsData property
    ///by downloading the icon Data from the given dictionary of City and icon ID
    private func assignValueToIconsData(fromIconsId iconsId: [City: String]) {
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: iconsId) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError): self.presentAlert(msg: networkError.message + #function)
                case .success(let iconsData):
                    self.assignValueToIconsDataAndEndRefreshing(iconsData: iconsData)
                }
            }
        }
    }

    ///Assigns a value to weatherTableViewDataSource's iconsData property
    ///with the downloaded  icon Data and ends the refreshing of the refresher property
    private func assignValueToIconsDataAndEndRefreshing(iconsData: ([City: Data])) {
        print("\(iconsData) iconsData " + #function)
        self.refresher.endRefreshing()
        self.weatherTableViewDataSource.iconsData = iconsData
        self.tableView.reloadData()
    }

    ///Presents an alert with the given message
    private func presentAlert(msg: String) {
        alertManager.presentErrorAlert(with: msg, presentingViewController: self)
    }
}
