//
//  WeatherUtility.swift
//  Weather
//
//  Created by Aditi Desai on 17/07/19.
//  Copyright © 2019 Aditi Desai. All rights reserved.
//

import Foundation
import UIKit

func showAlertWithMessage(message:String){
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    alert.present(alert, animated: true, completion: nil)
}
