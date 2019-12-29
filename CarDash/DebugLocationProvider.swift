//
//  DebugLocationProvider.swift
//  CarDash
//
//  Created by Thomas Jezequel on 28/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProvider {
  var delegate: LocationProviderDelegate? { get set }
}

protocol LocationProviderDelegate {
  func didRecieveLocationUpdate(locations: [CLLocation])
}

class DebugLocationProvider: LocationProvider {
  
  static let sharedInstance = DebugLocationProvider()
  
  // Playback Control
  var travel: Travel?
  var playbackTime: TimeInterval = 0.0
  var playbackDuration: TimeInterval = 0.0
  var currentTimer: Timer?
  
  var delegate: LocationProviderDelegate?
  
  init() {
    loadTravel(name: "work", extension: "json")
    startTravel()
  }
  
  func loadTravel(name: String, extension: String) {
    guard let file = Bundle.main.url(forResource: "work", withExtension: "json"),
      let data = try? Data(contentsOf: file) else {
        return
    }
    do {
      let decoder = JSONDecoder()
      let travel = try decoder.decode(Travel.self, from: data)
      self.travel = travel
    } catch let error {
      print(error)
    }
  }
  
  func startTravel() {
    scheduleNextTimer()
  }
  
  func scheduleNextTimer() {
    if currentTimer != nil {
      currentTimer?.invalidate()
    }
    guard let travel = self.travel else { return }
    let currentPoint = travel.points.last { (point) -> Bool in
      point.timeStamp <= playbackTime
    }!
    let nextPoint = travel.points.first { (point) -> Bool in
      point.timeStamp > playbackTime+1
    }
    guard let tNextPoint = nextPoint else { return }
    let location = makeLocation(currentPoint: currentPoint, nextPoint: tNextPoint)
    currentTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
      self.delegate?.didRecieveLocationUpdate(locations: [location])
      self.playbackTime += 1.0
      self.scheduleNextTimer()
    })
  }
  
  func makeLocation(currentPoint: TravelPoint, nextPoint: TravelPoint) -> CLLocation {
    let timeDelta = nextPoint.timeStamp - currentPoint.timeStamp
    let normalizedPlaybackTime = playbackTime - currentPoint.timeStamp
    let deltaRatio = normalizedPlaybackTime / timeDelta
    let curRadLat = currentPoint.latitude * .pi / 180
    let curRadLon = currentPoint.longitude * .pi / 180
    let nexRadLat = nextPoint.latitude * .pi / 180
    let nexRadLon = nextPoint.longitude * .pi / 180
    let finalLatitude = currentPoint.latitude + ((nextPoint.latitude - currentPoint.latitude) * deltaRatio)
    let finalLongitude = currentPoint.longitude + ((nextPoint.longitude - currentPoint.longitude) * deltaRatio)
    let LC1 = CLLocation(latitude: currentPoint.latitude, longitude: currentPoint.longitude)
    let LC2 = CLLocation(latitude: nextPoint.latitude, longitude: nextPoint.longitude)
    let dist = LC2.distance(from: LC1)
    let speed = dist/(nextPoint.timeStamp - currentPoint.timeStamp)
    let dLon = nexRadLon - curRadLon
    let X = cos(nexRadLat) * sin(dLon)
    let Y = cos(curRadLat) * sin(nexRadLat) - sin(curRadLat) * cos(nexRadLat) * cos(dLon)
    let bearadian = atan2(X,Y)
    let bearingDeg = bearadian * 180 / .pi
    let direction = (bearingDeg >= 0) ? bearingDeg : 360 + bearingDeg
    print("Bearing : \(bearingDeg) / Direction : \(direction)")
    return CLLocation(coordinate: CLLocationCoordinate2D(latitude: finalLatitude, longitude: finalLongitude), altitude: 0, horizontalAccuracy: 1, verticalAccuracy: 1, course: direction, speed: speed, timestamp: Date())
  }
  
}
