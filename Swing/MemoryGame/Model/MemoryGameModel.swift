//
//  MemoryGameModel.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/14.
//

import Foundation

struct MemoryGameModel<CardContent> where CardContent: Equatable{
    
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach({ cards[$0].isFaceUp = ($0 == newValue) }) }
    }
    
    mutating func choose(_ card: Card){
        // if let chosenIdex = index(of: card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
               !cards[chosenIndex].isFaceUp,
               !cards[chosenIndex].isMatched {
            if let potentialFaceUpCardIndex = indexOfTheOneAndOnlyFaceUpCard {
                // one card face up
                if cards[potentialFaceUpCardIndex].content == cards[chosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialFaceUpCardIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
               indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            print("chosenCard = \(cards[chosenIndex])")
        }
    }
    
    func index(of card: Card) -> Int? {
        for i in 0..<cards.count {
            if cards[i].id == card.id {
                return i
            }
        }
        return nil
    }
    
    init(numOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add card to cards array
        for pairIndex in 0..<numOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id:pairIndex*2, content: content))
            cards.append(Card(id:pairIndex*2 + 1, content: content))
        }
        cards = MemoryGameModel.shuffle(cards: cards)
    }
    
    static func shuffle( cards: Array<Card>) -> Array<Card> {
        var newCards: Array<Card> = cards
        for i in 0..<cards.count {
            let swapIndex = Int.random(in: 0..<cards.count)
            newCards.swapAt(i, swapIndex)
        }
        return newCards
    }
    
    mutating func shuffle() {
        for i in 0..<cards.count {
            let swapIndex = Int.random(in: 0..<cards.count)
            cards.swapAt(i, swapIndex)
        }
    }
    struct Card: Identifiable {
        let id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        
        // MARK: - Bouns Tims
        // this could give matcing bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        //can be zero which means "no bonus available" for this card
        //剩余时间，以秒为单位
        var bonusTimeLimit: TimeInterval = 6

        //how long this card has ever been face up
        //卡片朝上的时间
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up(and is still face up)
        //最后一次面朝上的时间
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in past
        // (i.e not including the current time it's been face up if it is currently so)
        //过去累积朝上的时间
        var pastFaceUpTime: TimeInterval = 0

        // how much time left befor the bonus opportunity runs out
        //还剩多少时间
        var bonusTimeRemaining: TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        //剩余百分比
        var bonusRemaining: Double{
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        //是否赚了积分
        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        //是否正在消耗积分时间
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
