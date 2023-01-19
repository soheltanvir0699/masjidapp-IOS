//
//  OnboardingViewController.swift
//  Salli
//
//  Created by Omar Khodr on 8/3/20.
//  Copyright © 2020 Omar Khodr. All rights reserved.
//

import UIKit
import CoreLocation

class OnboardingViewController: UIViewController {

    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var automaticLocationButton: UIButton!
    @IBOutlet weak var manualLocationButton: UIButton!
    
    let defaults = UserDefaults.standard
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        locationManager.delegate = self
        automaticLocationButton.rounded(cornerRadius: 8)
        manualLocationButton.rounded(cornerRadius: 8)
        // Do any additional setup after loading the view.
    }
    func requestLocation() {
        // Request location permission in case app isn't allowed
        locationManager.requestWhenInUseAuthorization()
        //request location
        locationManager.requestLocation()
    }
    @IBAction func didTapAutomaticLocationButton(_ sender: UIButton) {
        requestLocation()
        dismiss(animated: true, completion: nil)
        defaults.set(true, forKey: K.Keys.automaticLocation)
        defaults.set(true, forKey: K.Keys.needUpdatingSettings)
    }
}

extension OnboardingViewController: CLLocationManagerDelegate {
    //method that gets triggered when location, managed by CLLocationManager, is updated
    //input is self and array of fetched locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get last location fetched
        if let location = locations.last {
            //stop updating location while fetching from array
            locationManager.stopUpdatingLocation()
            //call method of prayer times manager to perform GET request from the API to fetch the latest prayer times and update the UI
           
        }
    }
    
    //in case updating location fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
