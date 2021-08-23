//
//  ScrollVGrid.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/22.
//

import SwiftUI

struct ScrollVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    
    var items: [Item]
    var aspectRatio: CGFloat
    var columnCount: Int
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, columnCount: Int = 2, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.columnCount = columnCount
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    let width: CGFloat = fitWidth(size: geometry.size)
                    LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0){
                        ForEach(items) { item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func fitWidth(size: CGSize) -> CGFloat {
        return floor(size.width / CGFloat(self.columnCount))
    }
}
