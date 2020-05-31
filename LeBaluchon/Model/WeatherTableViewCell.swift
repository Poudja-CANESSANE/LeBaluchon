//
//  WeatherTableViewCell.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 29/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    func updateWeatherCell(weatherObject: WeatherObject, iconImage: UIImage) {
        cityLabel.text = weatherObject.name
        descriptionLabel.text = weatherObject.description.capitalized
        minTempLabel.text = "\(weatherObject.tempMin)°C"
        maxTempLabel.text = "\(weatherObject.tempMax)°C"
        temperatureLabel.text = "\(weatherObject.temperature)°C"
        iconImageView.image = iconImage
    }
}
