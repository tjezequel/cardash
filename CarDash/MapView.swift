//
//  MapView.swift
//  CarDash
//
//  Created by Thomas Jezequel on 25/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  
  var location: CLLocation
  
  func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
    let map = MKMapView(frame: .zero)
    map.showsUserLocation = true
    return map
  }
  
  func updateUIView(_ map: MKMapView, context: UIViewRepresentableContext<MapView>) {
    let camera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: CLLocationDistance(floatLiteral: 200+location.speed*5), pitch: 80, heading: location.course)
    MKMapView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveLinear, animations: {
      map.setCamera(camera, animated: true)
    })
    
  }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: CLLocation(latitude: 48.3733, longitude: -4.3694))
    }
}
