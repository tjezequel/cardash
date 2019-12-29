//
//  CLLocationProvider.swift
//  CarDash
//
//  Created by Thomas Jezequel on 29/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import Foundation
import CoreLocation

class CLLocationProvider: NSObject ,LocationProvider, CLLocationManagerDelegate {
  
  static let sharedInstance = CLLocationProvider()
  
  var delegate: LocationProviderDelegate?
  let locationManager = CLLocationManager()
  
  override init() {
    super.init()
    askPermission()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.delegate = self
  }
  
  func askPermission() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    delegate?.didRecieveLocationUpdate(locations: locations)
  }
}
