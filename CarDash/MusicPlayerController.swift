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

class MusicPlayerController: ObservableObject {
  
  static let sharedInstance = MusicPlayerController()
  
  var player = MPMusicPlayerController.applicationMusicPlayer
  
  @Published var currentSong: MPMediaItem?
  @Published var playing: MPMusicPlaybackState
  @Published var volume: Float = 0.0
  
  var baseVolume: Float = 0.0
  
  init() {
    currentSong = player.nowPlayingItem
    playing = player.playbackState
    NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
      self.currentSong = self.player.nowPlayingItem
    }
  }
  
  func play() {
    player.play()
    playing = player.playbackState
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
  
  @objc func volumeChanged(notification:NSNotification)
  {
    let manager = LocationManager.sharedInstance
    let outVolume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as? Float
    //      let category = notification.userInfo!["AVSystemController_AudioCategoryNotificationParameter"]
    //      let reason = notification.userInfo!["AVSystemController_AudioVolumeChangeReasonNotificationParameter"]
    
    guard let volume = outVolume else { return }
    
    if volume != currentTheoricalVolume {
      baseVolume = volume-Float(manager.speed/750)
    }
  }
  
  var currentTheoricalVolume: Float {
    let manager = LocationManager.sharedInstance
    return Float(manager.speed/750) + baseVolume
  }
  
}

extension MusicPlayerController: LocationManagerDelegate {
  
  func didUpdateLocation(location: CLLocation) {
    self.volume = currentTheoricalVolume
  }
  
}
