//
//  VolumeView.swift
//  CarDash
//
//  Created by Thomas Jezequel on 26/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import SwiftUI
import MediaPlayer
import CoreLocation

extension MPVolumeView {
  static func setVolume(_ volume: Double) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
      slider?.setValue(Float(volume), animated: true)
    }
  }
  
  static func getVolume(completion: @escaping (Double?) -> Void) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
      completion(Double(slider?.value ?? 0))
    }
  }
}

struct VolumeView: UIViewRepresentable {
  
  var locationManager: CLLocation
  var volume: Double
  
  func makeUIView(context: UIViewRepresentableContext<VolumeView>) -> MPVolumeView {
    let view = MPVolumeView()
    return view
  }
  
  func updateUIView(_ volumeView: MPVolumeView, context: UIViewRepresentableContext<VolumeView>) {
    MPVolumeView.setVolume(volume)
  }
  
}

//struct VolumeView_Previews: PreviewProvider {
//    static var previews: some View {
//        VolumeView()
//    }
//}
