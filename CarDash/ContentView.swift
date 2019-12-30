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
  
  var integerSpeed: Int {
    return Int(locationManager.speed.rounded())
  }
  
  var body: some View {
    ZStack(alignment: .center){
      MapView(location: locationManager.lastKnownLocation).edgesIgnoringSafeArea(.all)
      VStack{
        HStack(spacing: 15) {
          ZStack(alignment: .center) {
            BlurView(style: colorScheme == .some(ColorScheme.light) ? .light : .dark)
            Circle().frame(width: 70, height: 70).foregroundColor(.clear).overlay(Circle().stroke(Color.primary, lineWidth: 4))
            Text("\(integerSpeed)").foregroundColor(.primary).font(Font.system(size: 24, weight: .bold))
          }.frame(width: 100, height: 100).cornerRadius(10)
          ZStack(alignment: .center) {
            BlurView(style: colorScheme == .some(ColorScheme.light) ? .light : .dark)
            Text("No navigation")
          }.frame(height: 100).cornerRadius(10)
        }
        Spacer()
        MusicPanel()
      }.padding(15).padding(.bottom, 20)
    }

  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
