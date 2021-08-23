//
//  ImageModel.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/22.
//

import Foundation

struct PictureModel {
    
    private(set) var pictures: Array<Picture>
    
    init(_ nameArr: Array<String>) {
        self.pictures = []
        for index in 0..<nameArr.count {
            let picture = Picture(id: index, imageName: nameArr[index])
            self.pictures.append(picture)
        }
    }
    
    struct Picture: Identifiable {
        var id: Int
        var imageName: String
    }
}
