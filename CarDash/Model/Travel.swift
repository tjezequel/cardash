//
//  Travel.swift
//  CarDash
//
//  Created by Thomas Jezequel on 28/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import Foundation

class Travel: Codable {
  var points: [TravelPoint] = []
  var date: Date = Date()
}
