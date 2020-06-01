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

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!



    // MARK: Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIWithDownloadedWeathers()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let weatherNetworkManager = WeatherNetworkManager(
            networkManager: ServiceContainer.networkManager,
            urlProvider: ServiceContainer.urlProvider)

    private let alertManager = ServiceContainer.alertManager

    ///Contains the downloaded WeatherObject
    private var weathers: [WeatherObject]?

    ///Contains the icons ID corresponding a City
    private var iconsId: [City: String] = [:]

    ///Contains the icons Data corresponding to a City
    private var iconsData: [City: Data] = [:]



    // MARK: Methods

    ///Updates the UI with the downloaded weathers
    private func updateUIWithDownloadedWeathers() {
        let cities = getCities()

        weatherNetworkManager.getWeathers(forCities: cities) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message + #function)
                case .success(let downloadedWeathers):
                    self.updateUI(withDownloadedWeathers: downloadedWeathers)
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

    private func updateUI(withDownloadedWeathers downloadedWeathers: [City: WeatherObject]) {
        self.populateIconsId(withWeathers: downloadedWeathers)
        self.assignValueToWeathers(fromDownloadedWeathers: downloadedWeathers)
        self.assignValueToIconsData(fromIconsId: self.iconsId)
    }

    ///Populates the iconsId property with the weathers'key as key and the WeatherObject's iconId property as value
    private func populateIconsId(withWeathers weathers: [City: WeatherObject]) {
        var iconIds: [City: String] = [:]
        weathers.forEach { iconIds[$0.key] = $0.value.iconId }
        self.iconsId = iconIds
        print("\(self.iconsId) iconsId " + #function)
    }

    ///Assigns a value to the weathers property from the given dictionary's values
    private func assignValueToWeathers(fromDownloadedWeathers weathers: [City: WeatherObject]) {
        let weathersArray: [WeatherObject] = Array(weathers.values)
        self.weathers = weathersArray
    }

    ///Assigns a value to iconsData property by downloading the icon Data from the given dictionary of City and icon ID
    private func assignValueToIconsData(fromIconsId iconsId: [City: String]) {
        weatherNetworkManager.getWeatherIconsData(forCitiesAndIconIds: iconsId) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError): self.presentAlert(msg: networkError.message + #function)
                case .success(let iconsData):
                    print("\(iconsData) iconsData " + #function)
                    self.iconsData = iconsData
                    self.tableView.reloadData()
                }
            }
        }
    }

    ///Presents an alert with the given message
    private func presentAlert(msg: String) {
        alertManager.presentAlert(with: msg, presentingViewController: self)
    }

    ///Returns an optionnal UIImage corresponding to the icon Data of the given WeatherObject from the given dictionary
    private func getIconImage(fromIconsData iconsData: [City: Data], weatherObject: WeatherObject) -> UIImage? {
        let iconsStringData = getIconsStringData(fromIconsCityData: iconsData)

        guard let data = iconsStringData[weatherObject.name] else {
            return nil
        }

        guard let iconImage = UIImage(data: data) else {
            return nil
        }
        print(weatherObject)
        print("\(iconImage) iconImage")
        return iconImage
    }

    ///Returns the given dictionary with the city's name as key
    private func getIconsStringData(fromIconsCityData iconsData: [City: Data]) -> [String: Data] {
        var iconsStringData: [String: Data] = [:]
        iconsData.forEach { iconsStringData[$0.key.name] = $0.value }
        return iconsStringData
    }
}



// MARK: - EXTENSIONS
extension WeatherTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let weatherCell = tableView.dequeueReusableCell(
            withIdentifier: "weatherCell",
            for: indexPath) as? WeatherTableViewCell else {
                return WeatherTableViewCell()
        }

        guard let weatherObject = weathers?[indexPath.row] else {
            return WeatherTableViewCell()
        }

        guard let iconImage = getIconImage(
            fromIconsData: iconsData,
            weatherObject: weatherObject) else {
            return WeatherTableViewCell()
        }

        weatherCell.updateWeatherCell(weatherObject: weatherObject, iconImage: iconImage)

        return weatherCell
    }
}

extension WeatherTableViewController: UITableViewDelegate {}
