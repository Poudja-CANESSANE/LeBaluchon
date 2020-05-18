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
    @IBOutlet weak var nycDescLabel: UILabel!
    @IBOutlet weak var nycIconLabel: UILabel!
    @IBOutlet weak var sltTempLabel: UILabel!
    @IBOutlet weak var sltDescLabel: UILabel!
    @IBOutlet weak var sltIconLabel: UILabel!

    lazy private var labels = [
        "nyc": [
            nycTempLabel,
            nycDescLabel,
            nycIconLabel],
        "slt": [
            sltTempLabel,
            sltDescLabel,
            sltIconLabel
        ]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUIWithDownloadedWeathers()
    }

    private func updateUIWithDownloadedWeathers() {
        WeatherNetworkManager.shared.getNYCAndSLTWeathers { (result) in
            switch result {
            case .success(let weathers):
                guard let weathers = weathers else { return }
                self.updateLabels(city: "nyc", from: weathers)
                self.updateLabels(city: "slt", from: weathers)
            case .failure(let networkError):
                self.presentAlert(msg: networkError.message)
            }
        }
    }

    private func updateLabels(city: String, from weathers: Weathers) {
        let range = city == "nyc" ? 0 : 1
        labels["\(city)"]?[0]?.text = "\(weathers.weathers[range].temperature)°C"
        labels["\(city)"]?[1]?.text = weathers.weathers[range].description.capitalized
        labels["\(city)"]?[2]?.text = weathers.weathers[range].main
    }

    private func presentAlert(msg: String) {
        let alertVC = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(action)
        present(alertVC,animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
