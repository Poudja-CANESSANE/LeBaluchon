//
//  ActivityIndicatorViewManager.swift
//  LeBaluchon
//
//  Created by Canessane Poudja on 03/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class ActivityIndicatorViewManager {
    var myActivityIndicator: UIActivityIndicatorView?
    private var backgroundView: UIView?

    func setupActivityIndicator(on view: UIView) {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        backgroundView = UIView(frame: view.bounds)
        guard let backgroundView = backgroundView else {return}
        backgroundView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        activityIndicator.center = backgroundView.center
        activityIndicator.startAnimating()
        backgroundView.addSubview(activityIndicator)

        view.addSubview(backgroundView)

//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

//        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        myActivityIndicator = activityIndicator
    }

    func removeActivityIndicator() {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }
}
