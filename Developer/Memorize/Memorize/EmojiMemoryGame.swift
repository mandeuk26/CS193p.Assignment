//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 강현준 on 2021/06/29.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let emojis = ["🚖", "🛵", "🚆", "🚍", "🛺", "🛫", "🏖", "🚔", "🛸", "🚁", "🏍", "🛳", "🚐", "🚛", "🚚"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 15) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        //objectWillChange.send()
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
