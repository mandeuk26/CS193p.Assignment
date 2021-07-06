//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 강현준 on 2021/06/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            cardView(for: card)
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0)
        } else {
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }
}


//Property Observers
//저장된 값이 변경될때마다 특정 동작을 수행하도록 설정할 수 있음
//computed variable과 다르다는 것을 명심!
//실제로 어딘가에 저장된 값이라는점!
//var isFaceUp: Bool {
//  willSet {
//      if newValue {
//          startUsingBonusTime()
//      } else {
//          stopUsingBounusTime()
//      }
//  }
//}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 20)).padding(5).opacity(0.5)
                    Text(card.content).font(font(in:geometry.size))
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}

//preview를 컨트롤하는 코드
//위에서 선언한 ContentView를 불러온다는 것을 명심하자.
