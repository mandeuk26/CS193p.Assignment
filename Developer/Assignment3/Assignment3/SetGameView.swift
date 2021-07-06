//
//  ContentView.swift
//  Assignment3
//
//  Created by 강현준 on 2021/07/05.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    var body: some View {
        VStack {
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
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card).onTapGesture{ game.choose(card) }
            }
            Spacer()
            HStack(alignment: .bottom) {
                Button {
                    game.reset()
                } label : {
                    VStack {
                        Image(systemName: "restart")
                        Text("Restart").font(.callout)
                    }
                }
                Spacer()
                Button {
                    game.add3Card()
                } label : {
                    VStack {
                        Image(systemName: "plus")
                        Text("Add Cards").font(.callout)
                    }.foregroundColor(game.checkPossible())
                }
            }
            .padding(.horizontal)
            .font(.title)
        }
    }
}

struct CardView: View {
    var card: SetGameViewModel.Card
    var body: some View {
        GeometryReader { geomety in
            drawCardWithModifiedConstants(size: geomety.size)
        }
    }
    
    @ViewBuilder
    func drawCardWithModifiedConstants(size: CGSize) -> some View {
        let cardCornerRadius = size.width > 45 ? DrawingConstants.cardCornerRadius : 0.1
        let cardPaddingSize = size.width > 45 ? DrawingConstants.cardPaddingSize : DrawingConstants.cardPaddingSize/2

        let shape = RoundedRectangle(cornerRadius: cardCornerRadius)
        ZStack {
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: DrawingConstants.cardBorderSize)
            LazyVGrid(columns: [GridItem(.fixed(size.width * DrawingConstants.imageScale))]) {
                repeatingShape(card: card)
            }
        }
        .foregroundColor(sellectLineColor(for: card))
        .padding(cardPaddingSize)
    }
    
    @ViewBuilder
    func repeatingShape(card: SetGameViewModel.Card) -> some View {
        if card.content3.value() > 0 { makeShape(card: card) }
        if card.content3.value() > 1 { makeShape(card: card) }
        if card.content3.value() > 2 { makeShape(card: card) }
    }
    
    @ViewBuilder
    func makeShape(card: SetGameViewModel.Card) -> some View {
        ZStack {
            switch card.content2 {
            case .oval : Capsule().addShade(shading: card.content4)
            case .diamond : Diamond().addShade(shading: card.content4)
            case .squid : Squid().addShade(shading: card.content4)
            }
        }
        .foregroundColor(card.content1.value())
        .aspectRatio(DrawingConstants.imageRatio, contentMode: .fit)
    }
    
    func sellectLineColor(for card: SetGameViewModel.Card) -> Color {
        switch card.isMatched {
        case .NotSelected: return .black
        case .Selected: return .blue
        case .ThreeAndSet: return .green
        case .ThreeNotSet: return .red
        }
    }
    
    private struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 10.0
        static let cardBorderSize: CGFloat = 2
        static let cardPaddingSize: CGFloat = 4
        static let imagePaddingSize: CGFloat = 4
        static let imageRatio: CGFloat = 2/1
        static let imageScale: CGFloat = 0.5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}

struct DrawingConstantsForShape {
    static let lineWidth:CGFloat = 2.0
    static let numberOfStrips:Int = 5
}

extension Shape {
    @ViewBuilder
    func addShade(shading: SetGameViewModel.CardShading) -> some View {
        switch shading {
        case .solid :
            self.fill()
            self.stroke(lineWidth: DrawingConstantsForShape.lineWidth)
        case .open :
            self.stroke(lineWidth: DrawingConstantsForShape.lineWidth)
        case .striped :
            self.striped()
        }
    }
    
    @ViewBuilder
    func striped(numberOfStrips: Int = DrawingConstantsForShape.numberOfStrips, borderLineWidth: CGFloat = DrawingConstantsForShape.lineWidth) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<numberOfStrips) { number in
                Color.white
                Rectangle()
                if number == numberOfStrips - 1 {
                    Color.white
                }
            }
            
        }
        .mask(self)
        .overlay(self.stroke(lineWidth: borderLineWidth))
    }
}


