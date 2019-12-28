//
//  AlbumInfo.swift
//  CarDash
//
//  Created by Thomas Jezequel on 28/12/2019.
//  Copyright © 2019 Thomas Jezequel. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct AlbumInfo: View {
  
  var currentSong: MPMediaItem?
  
    var body: some View {
        return HStack {
          Image(uiImage: currentSong?.artwork?.image(at: CGSize(width: 75, height: 75)) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 75, height: 75)
            .cornerRadius(5)
          VStack(alignment: .leading) {
            Text(currentSong?.title ?? "").font(Font.system(size: 24, weight: .bold))
            Text(currentSong?.artist ?? "").font(Font.system(size: 14))
            Text(currentSong?.albumTitle ?? "").font(Font.system(size: 14))
          }
          Spacer()
        }
    }
}

struct AlbumInfo_Previews: PreviewProvider {
    static var previews: some View {
        AlbumInfo()
    }
}
