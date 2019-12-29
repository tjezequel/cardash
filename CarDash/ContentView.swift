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
  
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @ObservedObject var locationManager = LocationManager.sharedInstance
  @ObservedObject var musicManager = MusicPlayerController.sharedInstance
  @State private var showImagePicker: Bool = false
  var formatter = NumberFormatter()
  
  init() {
    formatter.maximumFractionDigits = 0
  }
  
  var body: some View {
    ZStack(alignment: .center){
      MapView(location: locationManager.lastKnownLocation).edgesIgnoringSafeArea(.all)
      VStack{
        HStack {
          ZStack(alignment: .center) {
            BlurView(style: colorScheme == .some(ColorScheme.light) ? .light : .dark)
            Circle().frame(width: 70, height: 70).foregroundColor(.clear).overlay(Circle().stroke(Color.primary, lineWidth: 4))
            Text("\(formatter.string(from: NSNumber(value: locationManager.speed)) ?? "0")").foregroundColor(.primary).font(Font.system(size: 24, weight: .bold))
          }.frame(width: 100, height: 100).cornerRadius(10)
          Spacer()
          ZStack(alignment: .center) {
            BlurView(style: colorScheme == .some(ColorScheme.light) ? .light : .dark)
            Text("No navigation")
          }.frame(height: 100).cornerRadius(10)
        }
        Spacer()
        Button(action: {self.showImagePicker.toggle()}) {
          Text("Music")
        }
        .sheet(isPresented: self.$showImagePicker) {
             MusicMediaPicker()
        }
        ZStack {
          BlurView(style: colorScheme == .some(ColorScheme.light) ? .light : .dark)
          VStack(spacing: 20) {
            AlbumInfo(currentSong: musicManager.currentSong)
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
            VolumeView(locationManager: locationManager.lastKnownLocation, volume: musicManager.volume).frame(maxHeight: 30)
          }.padding(15)
          }.frame(height: 200).cornerRadius(10)
      }.padding(15).padding(.bottom, 20)
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
