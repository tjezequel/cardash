//
//  ContentView.swift
//  CarDash
//
//  Created by Thomas Jezequel on 25/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import SwiftUI
import SwiftUIBlurView

struct ContentView: View {
  
  @ObservedObject var locationManager = LocationManager.sharedInstance
  @ObservedObject var musicManager = MusicPlayerController.sharedInstance
  var formatter = NumberFormatter()
  
  init() {
    formatter.maximumFractionDigits = 0
  }
  
  var body: some View {
    ZStack(alignment: .center){
      MapView(location: locationManager.lastKnownLocation)
      VStack{
        ZStack(alignment: .center) {
          Circle().frame(width: 50, height: 50).foregroundColor(Color.red)
          Text("\(formatter.string(from: NSNumber(value: locationManager.speed)) ?? "0")").fontWeight(.bold).foregroundColor(.white)
        }
        Spacer()
        ZStack {
          BlurView(style: .light)
          VStack {
            HStack {
              Image(uiImage: musicManager.currentSong?.artwork?.image(at: CGSize(width: 75, height: 75)) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 75, height: 75)
                .cornerRadius(5)
              VStack(alignment: .leading) {
                Text(musicManager.currentSong?.title ?? "").fontWeight(.bold)
                Text(musicManager.currentSong?.artist ?? "")
                Text(musicManager.currentSong?.albumTitle ?? "")
              }
              Spacer()
            }
            Spacer()
            HStack(spacing: 60) {
              Image(systemName: "backward.end.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30)
              if musicManager.playing == .playing {
                Image(systemName: "pause.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).onTapGesture {
                  self.musicManager.pause()
                }
              } else {
                Image(systemName: "play.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).onTapGesture {
                  self.musicManager.play()
                }
              }
              Image(systemName: "forward.end.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30)
            }
            Spacer()
            VolumeView(locationManager: locationManager.lastKnownLocation, volume: musicManager.volume).frame(maxHeight: 30)
          }.padding(15)
        }.frame(maxWidth: .infinity, maxHeight: 250).cornerRadius(10)
      }.padding(15).padding(.bottom, 20)
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
