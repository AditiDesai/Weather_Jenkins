//
//  ViewController.swift
//  Weather
//
//  Created by Aditi Desai on 16/07/19.
//  Copyright © 2019 Aditi Desai. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var placeNameLabel : UILabel!
    @IBOutlet var weatherTypeLabel : UILabel!
    @IBOutlet var temperatureLabel : UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        askUserForLocationPermission()
    }
    
    func askUserForLocationPermission()  {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                showAlertWithMessage(message:"Please Allow the Location Permision to get weather of your city")
            case .authorizedAlways, .authorizedWhenInUse:
                print("locationEnabled")
            }
        } else {
            showAlertWithMessage(message:"Please Turn ON the location services on your device")
            print("locationDisabled")
        }
        manager.stopUpdatingLocation()
    }
}

