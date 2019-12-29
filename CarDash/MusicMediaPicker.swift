//
//  MusicMediaPicker.swift
//  CarDash
//
//  Created by Thomas Jezequel on 29/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct MusicMediaPicker: UIViewControllerRepresentable {
  typealias UIViewControllerType = MPMediaPickerController

  func makeUIViewController(context: UIViewControllerRepresentableContext<MusicMediaPicker>) -> MPMediaPickerController {
    let picker = MPMediaPickerController(mediaTypes: .music)
    picker.allowsPickingMultipleItems = true
    picker.showsCloudItems = true
    return picker
  }
  
  func updateUIViewController(_ uiViewController: MPMediaPickerController, context: UIViewControllerRepresentableContext<MusicMediaPicker>) {
    uiViewController.delegate = MusicPlayerController.sharedInstance
  }
}
