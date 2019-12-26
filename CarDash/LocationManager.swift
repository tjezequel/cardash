//
//  LocationManager.swift
//  CarDash
//
//  Created by Thomas Jezequel on 25/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation

protocol LocationManagerDelegate {
  func didUpdateLocation(location: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
  
  static var sharedInstance = LocationManager()
  
  let locationManager = CLLocationManager()
  let delegate = MusicPlayerController.sharedInstance
  
  var lastUpdateTime = Date()
  var updateTimer: Timer?
  @Published var lastKnownLocation: CLLocation
  ///Speed in Km/h
  @Published var speed: Double = 0
  
  override init() {
    lastKnownLocation = CLLocation(latitude: 48.3733, longitude: -4.3694)
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
    guard let location = locations.last else {
      print("#ERROR# - No location in update")
      return
    }
    self.speed = max(location.speed*3.6, 0)
    print("Speed = \(speed)")
    lastKnownLocation = location
    delegate.didUpdateLocation(location: location)
  }
  
}
