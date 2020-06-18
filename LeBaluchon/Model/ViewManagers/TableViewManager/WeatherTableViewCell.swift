//
//  WeatherTableViewCell.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 29/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    // MARK: - INTERNAL

    // MARK: Methods

    ///Updates the weather cell with the given WeatherObject and iconImage
    func updateWeatherCell(weatherObject: WeatherObject, iconImage: UIImage) {
        cityLabel.text = weatherObject.name
        descriptionLabel.text = weatherObject.description.capitalized
        minTempLabel.text = "\(weatherObject.tempMin)°C"
        maxTempLabel.text = "\(weatherObject.tempMax)°C"
        temperatureLabel.text = "\(weatherObject.temperature)°C"
        iconImageView.image = iconImage
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
}
