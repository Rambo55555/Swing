//
//  AspectRatioGrid.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/15.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width: CGFloat = fitWidth(itemCount: items.count, size: geometry.size, aspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0){
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func fitWidth(itemCount: Int, size: CGSize, aspectRatio: CGFloat) -> CGFloat {
        var rowCount = 1
        var columnCount = 1
        for i in 1...itemCount {
            columnCount = i
            let itemWidth = size.width / CGFloat(i)
            let itemHeight = itemWidth / aspectRatio
            rowCount = itemCount % i == 0 ? itemCount / i : itemCount / i + 1
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
        }
        
        return floor(size.width / CGFloat(columnCount))
    }
}





//
//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
