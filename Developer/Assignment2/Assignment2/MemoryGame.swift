//
//  MemoryGame.swift
//  Assignment2
//
//  Created by 강현준 on 2021/06/30.
//

import Foundation

struct MemoryGame<ContentType> where ContentType: Equatable {
    
    private(set) var cards: [Card]
    private(set) var theme: [Theme]
    private(set) var score: Int
    private(set) var themeIndex: Int?
    private var lastFlippedCard: Int?
    
    mutating func choose(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }),
           !cards[index].isFaceUp,
           !cards[index].isMatched {
            if let potentialLastFlippedCard = lastFlippedCard {
                if cards[index].content == cards[potentialLastFlippedCard].content {
                    score += 2
                    cards[index].isMatched = true
                    cards[potentialLastFlippedCard].isMatched = true
                } else {
                    if cards[index].isFlipped {
                        score -= 1
                    }
                    if cards[potentialLastFlippedCard].isFlipped {
                        score -= 1
                    }
                }
                cards[index].isFlipped = true
                cards[potentialLastFlippedCard].isFlipped = true
                lastFlippedCard = nil
            } else {
                for i in cards.indices {
                    cards[i].isFaceUp = false
                }
                lastFlippedCard = index
            }
            cards[index].isFaceUp = true
        }
    }
    
    mutating func addTheme(name: String, emojis: [ContentType], pairs: Int, color: String) {
        var numberOfPairs = pairs
        if emojis.count < numberOfPairs {
            numberOfPairs = emojis.count
        }
        theme.append(Theme(name: name, emojis: emojis, pairs: pairs, color: color))
    }
    
    mutating func reset() {
        if theme.count == 0 {
            return
        }
        themeIndex = Int.random(in: 0..<theme.count)
        cards = [Card]()
        score = 0
        let currentTheme = theme[themeIndex!]
        //var emojisSet = Array(currentTheme.emojis.shuffled()[0..<currentTheme.pairs]) //given pairs
        var randomPairs = currentTheme.emojis.count
        if randomPairs > 4 {
            randomPairs = Int.random(in: 4...randomPairs)
        }
        var emojisSet = Array(currentTheme.emojis.shuffled()[0..<randomPairs])
        emojisSet = (emojisSet+emojisSet).shuffled()
        for i in 0..<emojisSet.count {
            cards.append(Card(content: emojisSet[i], id: i))
        }
    }
    
    init() {
        cards = [Card]()
        theme = [Theme]()
        score = 0
    }
    
    struct Theme {
        var name:String
        var emojis:[ContentType]
        var pairs:Int
        var color:String
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var isFlipped = false
        var content:ContentType
        var id: Int
    }
}
