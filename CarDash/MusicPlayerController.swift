//
//  MusicPlayerController.swift
//  CarDash
//
//  Created by Thomas Jezequel on 26/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import Foundation
import MediaPlayer
import Combine
import CoreLocation

class MusicPlayerController: NSObject, ObservableObject {
  
  static let sharedInstance = MusicPlayerController()
  
  var player = MPMusicPlayerController.applicationMusicPlayer
  
  @Published var currentSong: MPMediaItem?
  @Published var playing: MPMusicPlaybackState
  @Published var volume: Double = 0.0
  
  let roundingNumber = 100.0
  
  var baseVolume: Double = 0.0
  
  override init() {
    self.baseVolume = SettingsManager.get(key: SettingsKeys.lastSessionBaseVolume)
    currentSong = player.nowPlayingItem
    playing = player.playbackState
    super.init()
    loadPreviousData()
    NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
      self.currentSong = self.player.nowPlayingItem
      guard var collection = SettingsManager.get(key: SettingsKeys.lastSessionContentId) as [UInt64]? else { return }
      collection.removeAll { (id) -> Bool in
        id == self.currentSong?.persistentID ?? 0
      }
      SettingsManager.set(key: SettingsKeys.lastSessionContentId, value: collection) 
    }
  }
  
  func play() {
    player.play()
    playing = player.playbackState
    currentSong = player.nowPlayingItem
  }
  
  func pause() {
    player.pause()
    playing = player.playbackState
  }
  
  func next() {
    player.skipToNextItem()
    currentSong = player.nowPlayingItem
  }
  
  func previous() {
    player.skipToPreviousItem()
    currentSong = player.nowPlayingItem
  }
  
  func loadPreviousData() {
    guard let collection = SettingsManager.get(key: SettingsKeys.lastSessionContentId) else { return }
    var mediaCollection = [MPMediaItem]()
    for item in collection {
      let predicate = MPMediaPropertyPredicate(value: item, forProperty: MPMediaItemPropertyPersistentID)
      let query = MPMediaQuery()
      query.addFilterPredicate(predicate)
      guard let items = query.items else { continue }
      for queryItem in items {
        mediaCollection.append(queryItem)
      }
    }
    self.player.setQueue(with: MPMediaItemCollection(items: mediaCollection))
    self.player.prepareToPlay()
  }
  
  @objc func volumeChanged(notification:NSNotification)
  {
    let manager = LocationManager.sharedInstance
    let outVolume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as? Double
    //      let category = notification.userInfo!["AVSystemController_AudioCategoryNotificationParameter"]
    //      let reason = notification.userInfo!["AVSystemController_AudioVolumeChangeReasonNotificationParameter"]
    
    guard let volume = outVolume else { return }
    
    let roundVolume = Double(round(volume*roundingNumber)/roundingNumber)
    
    print("Round Volume : \(roundVolume) / \(currentTheoricalVolume)")
    
    if roundVolume != currentTheoricalVolume {
      baseVolume = volume - Double(round((manager.speed/750)*roundingNumber)/roundingNumber)
      SettingsManager.set(key: SettingsKeys.lastSessionBaseVolume, value: Double(baseVolume))
    }
  }
  
  var currentTheoricalVolume: Double {
    let manager = LocationManager.sharedInstance
    return Double(round((manager.speed/750.0 + baseVolume) * roundingNumber)/roundingNumber)
  }
  
}

extension MusicPlayerController: LocationManagerDelegate {
  
  func didUpdateLocation(location: CLLocation) {
    self.volume = currentTheoricalVolume
  }
  
}

extension MusicPlayerController: MPMediaPickerControllerDelegate {
  
  func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
    let ids = mediaItemCollection.items.map { (item) -> UInt64 in
      return item.persistentID
    }
    SettingsManager.set(key: SettingsKeys.lastSessionContentId, value: ids)
    player.setQueue(with: mediaItemCollection)
    self.play()
  }
  
}
