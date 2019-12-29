//
//  UserLocationAnnotation.swift
//  CarDash
//
//  Created by Thomas Jezequel on 29/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import Foundation
import MapKit

class UserLocationAnnotation: NSObject, MKAnnotation {
  
  var coordinate: CLLocationCoordinate2D
  var title: String? = ""
  
  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }
  
}
