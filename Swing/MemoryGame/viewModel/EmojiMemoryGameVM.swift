//
//  EmojiMemoryGameVM.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/14.
//

import SwiftUI

class EmojiMemoryGameVM: ObservableObject {
    typealias Card = MemoryGameModel<String>.Card
    private static let emojis: Array<String> = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦","🥬"]
    
    private static func createMemoryGame() -> MemoryGameModel<String> {
        return MemoryGameModel<String>(numOfPairsOfCards: 10) { pairIndex in
            emojis[pairIndex]
        }
    }
    @Published
    private var model = createMemoryGame()
    
    var cards: Array<Card> {
        return model.cards;
    }
    
    // MARK: - Intents
    
    func resetGame() {
        model = EmojiMemoryGameVM.createMemoryGame()
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(card: Card) {
        model.choose(card)
    }

}
