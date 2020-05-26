//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 12/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var nycTempLabel: UILabel!
    @IBOutlet weak var nycTempMaxLabel: UILabel!
    @IBOutlet weak var nycTempMinLabel: UILabel!
    @IBOutlet weak var nycDescLabel: UILabel!
    @IBOutlet weak var nycIconLabel: UILabel!
    @IBOutlet weak var sltTempLabel: UILabel!
    @IBOutlet weak var sltTempMaxLabel: UILabel!
    @IBOutlet weak var sltTempMinLabel: UILabel!
    @IBOutlet weak var sltDescLabel: UILabel!
    @IBOutlet weak var sltIconLabel: UILabel!

    lazy private var labels = [
        Cities.newYorkCity.name: [
            nycTempLabel,
            nycTempMaxLabel,
            nycTempMinLabel,
            nycDescLabel,
            nycIconLabel],
        Cities.savignyLeTemple.name: [
            sltTempLabel,
            sltTempMaxLabel,
            sltTempMinLabel,
            sltDescLabel,
            sltIconLabel]
    ]

    private let weatherNetworkManager = WeatherNetworkManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUIWithDownloadedWeathers()
    }

    private func updateUIWithDownloadedWeathers() {
        weatherNetworkManager.getNYCAndSLTWeathers { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message)
                case .success(let weathers):
                    self.updateLabels(city: .newYorkCity, from: weathers)
                    self.updateLabels(city: .savignyLeTemple, from: weathers)
                }
            }
        }
    }

    private func updateLabels(city: Cities, from weathers: [WeatherObject]) {
        let range = city == .newYorkCity ? 0 : 1
        labels["\(city.name)"]?[0]?.text = "\(weathers[range].temperature)°C"
        labels["\(city.name)"]?[1]?.text = "\(weathers[range].tempMax)°C"
        labels["\(city.name)"]?[2]?.text = "\(weathers[range].tempMin)°C"
        labels["\(city.name)"]?[3]?.text = weathers[range].description.capitalized
        labels["\(city.name)"]?[4]?.text = WeatherIcon.weatherIcons[weathers[range].main]
    }

    private func presentAlert(msg: String) {
        let alertVC = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(action)
        present(alertVC,animated: true)
    }
}
