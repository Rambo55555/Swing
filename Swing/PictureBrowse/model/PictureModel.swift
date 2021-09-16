//
//  ImageModel.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/22.
//

import Foundation
import SwiftUI

struct PictureModel {
    
    private(set) var pictures: Array<Picture>
    
    init() {
        self.pictures = (1...20).map { Picture(imageName: "picture-\($0)") }
        for picture in self.pictures {
            picture.fetchData()
        }
    }
    init(_ nameArr: Array<String>) {
        self.pictures = []
        for index in 0..<nameArr.count {
            let picture = Picture(imageName: nameArr[index])
            self.pictures.append(picture)
        }
    }
    
    
    struct Picture: Identifiable {
        var id = UUID()
        var imageName: String
        // url: https://images.pexels.com/photos/1005644/pexels-photo-1005644.jpeg
        var urlStr: String? = "https://images.pexels.com/photos/1005644/pexels-photo-1005644.jpeg"
        var data: Data?
        var image: UIImage?
        
        mutating func fetchData() {
            guard let url = URL(string: urlStr!) else { return }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.data = data
                    }
                }
                task.resume()
        }
        
        mutating func setData(data: Data) {
            self.data = data
            self.image = UIImage(data: self.data!)
        }
        mutating func setImage() {
            self.image = UIImage(data: self.data!)
        }
    }
}
