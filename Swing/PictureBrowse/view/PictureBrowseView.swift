//
//  SwiftUIView.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/21.
//

import SwiftUI
typealias Picture = PictureBrowseVM.Picture
struct PictureBrowseView: View {
    @ObservedObject
    var pictureModel = PictureBrowseVM()
    private var gridItemLayout = [GridItem(), GridItem()]
    var body: some View {
        GeometryReader { geometry in
            ScrollVGrid(items: pictureModel.pictures, aspectRatio: 2/3, columnCount: 2) { picture in
                PictureView(picture: picture).padding(4)
            }
        }
    }
}

struct PictureView: View {
    
    var picture: Picture
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle().foregroundColor(.blue)
                Image(systemName: picture.imageName)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PictureBrowseView()
    }
}
