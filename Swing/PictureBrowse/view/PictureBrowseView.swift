//
//  SwiftUIView.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/21.
//

import SwiftUI
typealias Picture = PictureBrowseVM.Picture
struct PictureBrowseView: View {
    
    @ObservedObject var pictureModel = PictureBrowseVM()
    @State var colNum = 3
    private var gridItemLayout = [GridItem(), GridItem()]
    
    var body: some View {
        ScrollVGrid(items: pictureModel.pictures, aspectRatio: 2/3, columnCount: colNum) { picture in
            PictureView(picture: picture).padding(4)
        }
        .animation(.interactiveSpring())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    //self.gridLayout = Array(repeating: .init(.flexible()), count: self.gridLayout.count % 4 + 1)
                    colNum = colNum + 1
                }) {
                    Image(systemName: "square.grid.2x2")
                        .font(.title)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct PictureView: View {
    
    var picture: Picture
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .cornerRadius(10)
                    .shadow(color: Color.primary.opacity(0.3), radius: 1)
                //Text(picture.imageName)
                if picture.image != nil {
                    Image(uiImage: picture.image ?? UIImage())
                }
//                Image(samplePhotos[index].name)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(minWidth: 0, maxWidth: .infinity)
//                    .frame(height: 200)
//                    .cornerRadius(10)
//                    .shadow(color: Color.primary.opacity(0.3), radius: 1)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PictureBrowseView()
    }
}
