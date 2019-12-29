//
//  SettingsManager.swift
//  CarDash
//
//  Created by Thomas Jezequel on 29/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import Foundation

enum SettingsKeys: String {
  case lastSessionBaseVolume
  case lastSessionContentId
}

class SettingsManager {
  
  static let defaults = UserDefaults.standard
  
  static func get(key: SettingsKeys) -> Double {
    return defaults.double(forKey: key.rawValue)
  }
  
  static func set(key: SettingsKeys, value: Double) {
    defaults.set(value, forKey: key.rawValue)
  }
  
  static func get(key: SettingsKeys) -> [UInt64]? {
    return defaults.array(forKey: SettingsKeys.lastSessionContentId.rawValue) as? [UInt64]
  }
  
  static func set(key: SettingsKeys, value: [UInt64]) {
    defaults.set(value, forKey: SettingsKeys.lastSessionContentId.rawValue)
  }
  
}
