//
//  WeatherTableViewViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 29/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherTableViewController: UIViewController {
    // MARK: - INTERNAL

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

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!



    // MARK: Properties

    private let weatherNetworkManager = WeatherNetworkManager(
            networkService: ServiceContainer.networkService,
            weatherUrlProvider: ServiceContainer.weatherUrlProvider)

    private let alertManager = ServiceContainer.alertManager
    private let weatherTableViewDataSource = WeatherTableViewDataSource()
    private let weatherTableViewDelegateHandler = WeatherTableViewDelegateHandler()

    private let refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateUIWithDownloadedWeathers), for: .valueChanged)
        return refreshControl
    }()


    // MARK: Methods

    ///Sets the dataSource, the delegate and the refreshControl properties of the tableView
    private func setupTableView() {
        tableView.dataSource = weatherTableViewDataSource
        tableView.delegate = weatherTableViewDelegateHandler
        tableView.refreshControl = refresher
    }

    ///Updates the UI with the downloaded weathers
    @objc private func updateUIWithDownloadedWeathers() {
        weatherNetworkManager.getWeathers(forCities: City.allCases) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message)
                case .success(let downloadedWeathers):
                    self.weatherTableViewDataSource.populateProperties(withDownloadedWeathers: downloadedWeathers)
                    self.downloadIconDataAndPopulateIconsData(fromIconsId: self.weatherTableViewDataSource.iconsId)
                }
            }
        }
    }

    ///Assigns a value to weatherTableViewDataSource's iconsData property
    ///by downloading the icon Data from the given dictionary of City and icon ID
    private func downloadIconDataAndPopulateIconsData(fromIconsId iconsId: [City: String]) {
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: iconsId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message)
                case .success(let iconsData):
                    self.assignValueToIconsDataAndEndRefreshing(iconsData: iconsData)
                }
            }
        }
    }

    ///Assigns a value to weatherTableViewDataSource's iconsData property
    ///with the downloaded  icon Data and ends the refreshing of the refresher property
    private func assignValueToIconsDataAndEndRefreshing(iconsData: ([City: Data])) {
        refresher.endRefreshing()
        weatherTableViewDataSource.iconsData = iconsData
        tableView.reloadData()
    }

    ///Presents an alert with the given message
    private func presentAlert(msg: String) {
        alertManager.presentErrorAlert(with: msg, presentingViewController: self)
    }
}
