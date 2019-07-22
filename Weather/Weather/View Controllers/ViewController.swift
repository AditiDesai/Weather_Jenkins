//
//  ViewController.swift
//  Weather
//
//  Created by Aditi Desai on 16/07/19.
//  Copyright © 2019 Aditi Desai. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var placeNameLabel : UILabel!
    @IBOutlet var weatherTypeLabel : UILabel!
    @IBOutlet var temperatureLabel : UILabel!
    
    let locationManager = CLLocationManager()
    var lat = 0.0
    var lng = 0.0
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
            loadCurrentWeather()
        }
    }
    
    func loadCurrentWeather() {
        let url = "\(BASEURL)\(WEATHER)lat=\(lat)&lon=\(lng)&appid=\(APIKEY)&units=\(units)"
        
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                if let weather = json["weather"] as? [[String:Any]]   {
                    if let main = weather[0]["main"] as? String {
                        print("main=\(main)")
                        self.weatherTypeLabel.text = main
                    }
                    if let description = weather[0]["description"] as? String {
                        print("description=\(description)")
                        self.weatherTypeLabel.text = "\(self.weatherTypeLabel.text!), \(description)"
                    }
                }
                
                if let main = json["main"] as? [String:Any]   {
                    if let temp = main["temp"] as? NSNumber {
                        print("temp=\(temp)")
                        self.temperatureLabel.text = "\(temp) \(unit)"
                    }
                    if let temp_max = main["temp_max"] as? NSNumber, let temp_min = main["temp_min"] as? NSNumber {
                        print("temp_max=\(temp_max) and temp_min=\(temp_min)")
                    }
                }
                if let name = json["name"] as? String  {
                    print("name=\(name)")
                    self.placeNameLabel.text = name
                }
                
            }
            
        }
    }
}

