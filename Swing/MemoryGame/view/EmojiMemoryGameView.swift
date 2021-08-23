//
//  ContentView.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/8.
//

import SwiftUI
/// This is an EmojiMemoryGameView
struct EmojiMemoryGameView: View {
    
    @ObservedObject
    var game: EmojiMemoryGameVM
    
    @Namespace private var dealingNamespace
    
    @State var emojiCount = 20
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                Spacer()
                bottomBtn
            }
            deckBody
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGameVM.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGameVM.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGameVM.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGameVM.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear// Rectangle().opacity(0)
            } else {
                CardView(card:  card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of:card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card: card)
                        }
                    }
            }
        }
        .padding(.horizontal)
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            // "deal" cards
            
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var bottomBtn: some View {
        HStack {
            resetBtn
            Spacer()
            shuffleBtn
        }
        .padding(.horizontal)
    }
    
//    @ViewBuilder
//    private func cardView(for card: EmojiMemoryGmaeVM.Card) -> some View {
//        if card.isMatched && !card.isFaceUp {
//            Rectangle().opacity(0)
//        } else {
//            CardView(card:  card)
//                .padding(4)
//                .onTapGesture {
//                game.choose(card: card)
//            }
//        }
//    }
    
    var removeBtn: some View {
        Button {
            if emojiCount > 0 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
        .font(.largeTitle)
    }

    var addBtn: some View {
        Button {
            if emojiCount < game.cards.count {
                emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
        .font(.largeTitle)
    }
    
    var resetBtn: some View {
        Button {
            withAnimation {
                dealt = []
                game.resetGame()
            }
        } label: {
            Text("Reset")
        }
        .font(.title)
    }
    
    var shuffleBtn: some View {
        Button {
            withAnimation {
                game.shuffle()
            }
        } label: {
            Text("Shuffle")
        }
        .font(.title)
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGameVM.Card
    @State private var animateBonusRemaining: Double = 0
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animateBonusRemaining)*360-90), clockWise: false)
                            .onAppear {
                                animateBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animateBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90), clockWise: false)
                    }
                }
                    .padding(5)
                    .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.75
        static let fontSize: CGFloat = 32
    }
}

//extension String: Identifiable {
//    public var id: ObjectIdentifier {
//        return self
//    }
//}































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGameVM()
        game.choose(card: game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
