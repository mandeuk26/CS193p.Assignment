//
//  ContentView.swift
//  Assignment4
//
//  Created by 강현준 on 2021/07/09.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    @Namespace private var dealingNamespace
    @State private var dealt = Set<Int>()
    @State private var matched = Set<Int>()
    @State private var count = 0
    
    private func deal(_ card: SetGameViewModel.Card) {
        dealt.insert(card.id)
    }

    private func isUndealt(_ card: SetGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func match(_ card: SetGameViewModel.Card) {
        matched.insert(card.id)
    }
    
    private func isMatch(_ card: SetGameViewModel.Card) -> Bool {
        matched.contains(card.id)
    }

    private func zIndex(of card: SetGameViewModel.Card) -> Double {
        -Double(game.deck.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private func dealAnimation(for card: SetGameViewModel.Card, count: Int, userDelay: Double = 0) -> Animation {
        var delay: Double = 0
        if let index = game.deck.firstIndex(where: { $0.id == card.id }) {
            if index - count < 0 {
                return Animation.default
            }
            delay = Double(index-count) * CardConstant.delayAmount + userDelay
        }
        return Animation.easeInOut(duration: CardConstant.dealDuration).delay(delay)
    }
    
    var body: some View {
        VStack {
            upperBody
            gameBody
            bottomBody
        }
        
    }
    
    var upperBody: some View {
        ZStack {
            Text("Set Game!")
                .font(.title)
            HStack {
                Spacer()
                Text("Score : \(game.score)")
                    .font(.subheadline)
                    .padding(.top)
            }.padding(.horizontal)
        }
    }

    var gameBody: some View {
        AspectVGrid(items: game.deck.filter({ $0.isDealt }), aspectRatio: CardConstant.aspectRatio) { card in
            if isUndealt(card) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .zIndex(zIndex(of: card))
                    .onAppear() {
                        withAnimation(dealAnimation(for: card, count: count, userDelay: CardConstant.onAppearDelay)){
                            game.faceUp(card)
                        }
                    }
                    .onTapGesture {
                        for card in game.deck.filter({ $0.isMatched == .ThreeAndSet}) {
                            withAnimation(.easeInOut(duration: CardConstant.eraseDuration)) {
                                match(card)
                            }
                        }
                        game.choose(card)
                        
                        if game.cardCount < 12 {
                            count = game.deckCount
                            game.add3Card()
                            for card in game.deck.filter({ $0.isDealt }) {
                                withAnimation(dealAnimation(for: card, count: count)) {
                                    deal(card)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    var bottomBody: some View {
        HStack {
            pileBody
            Spacer()
            Button("Reset!") {
                withAnimation {
                    dealt = []
                    matched = []
                    count = 0
                    game.reset()
                }
            }
            Spacer()
            deckBody
        }
        .padding(.horizontal)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstant.deckWidth, height: CardConstant.deckHeight)
        .onTapGesture {
            count = game.deckCount
            if game.isFirst {
                game.addCardStart()
            } else {
                game.add3Card(penalty: game.answerExist())
            }
            
            for card in game.deck.filter({ $0.isDealt }) {
                withAnimation(dealAnimation(for: card, count: count)) {
                    deal(card)
                }
            }
        }
    }
    
    var pileBody: some View {
        ZStack {
            ForEach(game.deck.filter(isMatch)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstant.deckWidth, height: CardConstant.deckHeight)
    }
    
    struct CardConstant {
        static let delayAmount: Double = 0.3
        static let dealDuration: Double = 0.5
        static let eraseDuration: Double = 0.5
        static let onAppearDelay: Double = 0.5
        static let color: Color = .red
        static let deckWidth = deckHeight * aspectRatio
        static let deckHeight: CGFloat = 90
        static let aspectRatio: CGFloat = 2/3
    }
}

struct CardView: View {
    var card: SetGameViewModel.Card
    var body: some View {
        Shapify(card: card)
            .modifier(Cardify(isFaceUp: card.isFaceUp))
            .foregroundColor(sellectLineColor(for: card))
    }
    
    func sellectLineColor(for card: SetGameViewModel.Card) -> Color {
        switch card.isMatched {
        case .NotSelected: return .black
        case .Selected: return .blue
        case .ThreeAndSet: return .green
        case .ThreeNotSet: return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}


