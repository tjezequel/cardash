//
//  TravelData.swift
//  CarDash
//
//  Created by Thomas Jezequel on 28/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import Foundation
import CoreLocation

class TravelPoint: Codable {
  
  var longitude: Double
  var latitude: Double
  var timeStamp: TimeInterval
  
  init(
    longitude: Double,
    latitude: Double,
    timeStamp: TimeInterval
  ) {
    self.longitude = longitude
    self.latitude = latitude
    self.timeStamp = timeStamp
  }
  
}
