//
//  WeatherTableViewViewController.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 29/05/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class WeatherTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var weathers: [WeatherObject]?

    private var iconsId: [City: String] = [:]
    private var iconsData: [City: Data] = [:]

    private let weatherNetworkManager = WeatherNetworkManager(
            networkManager: ServiceContainer.networkManager,
            urlProvider: ServiceContainer.urlProvider)

    private let alertManager = ServiceContainer.alertManager

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIWithDownloadedWeathers()
//        updateImageWithWeatherIcon(icons: self.iconsId)
    }

    private func updateUIWithDownloadedWeathers() {
        weatherNetworkManager.getWeathers(forCities: [.newYork, .savignyLeTemple, .paris]) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(msg: networkError.message + #function)
                case .success(let downloadedWeathers):
                    self.populateIconsId(withWeathers: downloadedWeathers)
                    self.assignValueToWeathers(fromDownloadedWeathers: downloadedWeathers)
                    self.assignValueToIconsData(fromIconsId: self.iconsId)
                }
            }
        }
    }

    private func populateIconsId(withWeathers weathers: [City: WeatherObject]) {
        guard let nyIconId = weathers[.newYork]?.iconId else {
            self.presentAlert(msg: "Cannot unwrap nyIcon !")
            return
        }

        guard let sltIconId = weathers[.savignyLeTemple]?.iconId else {
            self.presentAlert(msg: "Cannot unwrap sltIcon !")
            return
        }

        guard let parisIconId = weathers[.paris]?.iconId else {
            self.presentAlert(msg: "Cannot unwrap parisIcon !")
            return
        }

        self.iconsId[.newYork] = nyIconId
        self.iconsId[.savignyLeTemple] = sltIconId
        self.iconsId[.paris] = parisIconId
        print("\(self.iconsId) iconsId " + #function)
    }

    private func assignValueToWeathers(fromDownloadedWeathers weathers: [City: WeatherObject]) {
        var weathersArray: [WeatherObject] = []

        for (_, weather) in weathers {
            let weather = weather
            weathersArray.append(weather)
        }

        self.weathers = weathersArray
    }

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

    private func presentAlert(msg: String) {
        alertManager.presentAlert(with: msg, presentingViewController: self)
    }

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

    private func getIconsStringData(fromIconsCityData iconsData: [City: Data]) -> [String: Data] {
        var iconsStringData: [String: Data] = [:]

        for (city, data) in iconsData {
            iconsStringData[city.name] = data
        }
        return iconsStringData
    }
}

extension WeatherTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else {return WeatherTableViewCell()}

//        print("\(indexPath.row) indexPath.row")
//        print("\(String(describing: weathers?.count)) weathers?.count")
//        print("\(String(describing: weathers?[0])) weathers?[0]")
//        print("\(String(describing: weathers?[1])) weathers?[1]")
//        print("\(String(describing: weathers?[2])) weathers?[2]")

        guard let weatherObject = weathers?[indexPath.row] else {
//            presentAlert(msg: "Cannot unwrap weatherObject !")
            return WeatherTableViewCell()
        }

        guard let iconImage = getIconImage(fromIconsData: iconsData, weatherObject: weatherObject) else {
            return WeatherTableViewCell()
        }

        weatherCell.updateWeatherCell(weatherObject: weatherObject, iconImage: iconImage)

        return weatherCell
    }
}

extension WeatherTableViewController: UITableViewDelegate {}
