//
//  WeatherTableViewDataSource.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 03/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherTableViewDataSource: NSObject, UITableViewDataSource {
    // MARK: - INTERNAL

    // MARK: Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let weatherCell = tableView.dequeueReusableCell(
            withIdentifier: CellId.weather.rawValue,
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



    // MARK: - PRIVATE

    // MARK: Properties

    ///Contains the downloaded WeatherObject
    private var weathers: [WeatherObject]?

    ///Contains the icons ID corresponding a City
    var iconsId: [City: String] = [:]

    ///Contains the icons Data corresponding to a City
    var iconsData: [City: Data] = [:]



    // MARK: Methods

    func populateProperties(withDownloadedWeathers downloadedWeathers: [City: WeatherObject]) {
        self.populateIconsId(withWeathers: downloadedWeathers)
        self.populateWeathers(fromDownloadedWeathers: downloadedWeathers)
    }

    ///Populates the iconsId property with the weathers'key as key and the WeatherObject's iconId property as value
    private func populateIconsId(withWeathers weathers: [City: WeatherObject]) {
        var iconIds: [City: String] = [:]
        weathers.forEach { iconIds[$0.key] = $0.value.iconId }
        self.iconsId = iconIds
    }

    ///Assigns a value to the weathers property from the given dictionary's values
    private func populateWeathers(fromDownloadedWeathers weathers: [City: WeatherObject]) {
        let weathersArray: [WeatherObject] = Array(weathers.values)
        self.weathers = weathersArray
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
        return iconImage
    }

    ///Returns the given dictionary with the city's name as key
    private func getIconsStringData(fromIconsCityData iconsData: [City: Data]) -> [String: Data] {
        var iconsStringData: [String: Data] = [:]
        iconsData.forEach { iconsStringData[$0.key.name] = $0.value }
        return iconsStringData
    }
}
