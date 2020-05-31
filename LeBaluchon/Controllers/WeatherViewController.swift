//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 12/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var nyTempLabel: UILabel!
    @IBOutlet weak var nyTempMaxLabel: UILabel!
    @IBOutlet weak var nyTempMinLabel: UILabel!
    @IBOutlet weak var nyDescLabel: UILabel!
    @IBOutlet weak var nyIconImage: UIImageView!
    @IBOutlet weak var sltTempLabel: UILabel!
    @IBOutlet weak var sltTempMaxLabel: UILabel!
    @IBOutlet weak var sltTempMinLabel: UILabel!
    @IBOutlet weak var sltDescLabel: UILabel!
    @IBOutlet weak var sltIconImage: UIImageView!

    lazy private var labels = [
        City.newYork: [
            nyTempLabel,
            nyTempMaxLabel,
            nyTempMinLabel,
            nyDescLabel],
        City.savignyLeTemple: [
            sltTempLabel,
            sltTempMaxLabel,
            sltTempMinLabel,
            sltDescLabel]
    ]

    private let weatherNetworkManager = WeatherNetworkManager(
        networkManager: ServiceContainer.networkManager,
        urlProvider: ServiceContainer.urlProvider)

    private let alertManager = ServiceContainer.alertManager

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUIWithDownloadedWeathers()
    }

    private func updateUIWithDownloadedWeathers() {
        weatherNetworkManager.getWeathers(forCities: [.newYork, .savignyLeTemple]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message + #function)
                case .success(let weathers):
                    guard let nyIcon = weathers[.newYork]?.iconId else {
                        self.presentAlert(msg: "Cannot unwrap nyIcon !")
                        return
                    }

                    guard let sltIcon = weathers[.savignyLeTemple]?.iconId else {
                        self.presentAlert(msg: "Cannot unwrap sltIcon !")
                        return
                    }

                    self.updateImageViewWithWeatherIcon(imageView: self.nyIconImage, iconId: nyIcon)
                    self.updateImageViewWithWeatherIcon(imageView: self.sltIconImage, iconId: sltIcon)
                    self.updateLabels(city: .newYork, from: weathers[.newYork]!)
                    self.updateLabels(city: .savignyLeTemple, from: weathers[.savignyLeTemple]!)
                }
            }
        }
    }

    private func updateImageViewWithWeatherIcon(imageView: UIImageView, iconId: String) {
        weatherNetworkManager.getWeatherIconDataForWeatherViewController(iconId: iconId) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError): self.presentAlert(msg: networkError.message + #function)
                case .success(let data):
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }

    private func updateLabels(city: City, from weather: WeatherObject) {
        labels[city]?[0]?.text = "\(weather.temperature)°C"
        labels[city]?[1]?.text = "\(weather.tempMax)°C"
        labels[city]?[2]?.text = "\(weather.tempMin)°C"
        labels[city]?[3]?.text = weather.description.capitalized
    }

    private func presentAlert(msg: String) {
        alertManager.presentAlert(with: msg, presentingViewController: self)
    }
}
