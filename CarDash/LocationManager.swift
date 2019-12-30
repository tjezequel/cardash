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

class LocationManager: LocationProviderDelegate, ObservableObject {
  
  static var sharedInstance = LocationManager()
  
  var debugLocationProvider = DebugLocationProvider.sharedInstance
  var realLocationProvider = CLLocationProvider.sharedInstance
  
  let delegate = MusicPlayerController.sharedInstance
  
  var lastUpdateTime = Date()
  var updateTimer: Timer?
  @Published var lastKnownLocation: CLLocation
  ///Speed in Km/h
  @Published var speed: Double = 0
  
  init() {
    lastKnownLocation = CLLocation(latitude: 48.381963, longitude: -4.350903)
//    debugLocationProvider.delegate = self
    realLocationProvider.delegate = self
  }
  
  func didRecieveLocationUpdate(locations: [CLLocation]) {
    guard let location = locations.last else {
      print("#ERROR# - No location in update")
      return
    }
    self.speed = max(location.speed*3.6, 0)
    lastKnownLocation = location
    delegate.didUpdateLocation(location: location)
  }
  
}
