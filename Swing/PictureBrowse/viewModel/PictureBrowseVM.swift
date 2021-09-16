//
//  ImageVM.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/22.
//

import SwiftUI

class PictureBrowseVM: ObservableObject {
    typealias Picture = PictureModel.Picture
    
    private static var pictureNames = ["circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle","circle"]
    @Published var model: PictureModel = createModel(pictureNames)
    
    var pictures: Array<Picture> {
        return model.pictures
    }
    
    private static func createModel(_ nameArr: Array<String>) -> PictureModel {
        return PictureModel()
    }
}
