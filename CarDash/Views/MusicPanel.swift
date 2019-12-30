//
//  MusicPanel.swift
//  CarDash
//
//  Created by Thomas Jezequel on 30/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import SwiftUI

struct MusicPanel: View {
  
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @State var musicManager = MusicPlayerController.sharedInstance
  @State var locationManager = LocationManager.sharedInstance
  @State var showPlaylistPicker = false
  
  var body: some View {
    ZStack {
      BlurView(style: colorScheme == .some(ColorScheme.light) ? .light : .dark)
      if !showPlaylistPicker {
        VStack(spacing: 20) {
          AlbumInfo(currentSong: musicManager.currentSong).onTapGesture {
            withAnimation {
              self.showPlaylistPicker.toggle()
            }
          }
          HStack(spacing: 60) {
            Image(systemName: "backward.end.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).onTapGesture {
              self.musicManager.previous()
            }
            if musicManager.playing == .playing {
              Image(systemName: "pause.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).onTapGesture {
                self.musicManager.pause()
              }
            } else {
              Image(systemName: "play.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).onTapGesture {
                self.musicManager.play()
              }
            }
            Image(systemName: "forward.end.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).onTapGesture {
              self.musicManager.next()
            }
          }
          VolumeView(locationManager: locationManager.lastKnownLocation, volume: musicManager.volume).frame(maxHeight: 30.0)
        }.padding(15)
      } else {
        VStack {
          Text("Music Picker")
        }
      }
    }.frame(height: showPlaylistPicker ? nil : 200).cornerRadius(10)
  }
}

struct MusicPanel_Previews: PreviewProvider {
    static var previews: some View {
        MusicPanel()
    }
}
