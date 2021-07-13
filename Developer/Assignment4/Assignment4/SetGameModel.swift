//
//  SetGameModel.swift
//  Assignment4
//
//  Created by 강현준 on 2021/07/09.
//

import Foundation

struct SetGame<Content1, Content2, Content3, Content4> where Content1: Equatable, Content2: Equatable, Content3: Equatable, Content4: Equatable{
    private(set) var deck:[Card]
    private(set) var score = 0
    private(set) var isFirst = true
    private(set) var cardCount = 0
    private(set) var deckCount = 0
    private var selected: [Int] = []
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = deck.firstIndex(where: { card.id == $0.id }) {
            if selected.count == 3 {
                var isReturn = false
                for i in selected {
                    if deck[i].isMatched == .ThreeAndSet {
                        deck[i].isDealt = false
                        cardCount -= 1
                        if i == chosenIndex { isReturn = true }
                    } else {
                        deck[i].isMatched = .NotSelected
                    }
                }
                
                selected = []
                if isReturn {
                    return
                }
            }
            
            if let selectedIndex = selected.firstIndex(where: {$0 == chosenIndex}) {
                selected.remove(at: selectedIndex)
                deck[chosenIndex].isMatched = .NotSelected
            } else {
                selected.append(chosenIndex)
                deck[chosenIndex].isMatched = .Selected
            }
            
            if selected.count == 3 {
                if compare3Cards(deck[selected[0]], deck[selected[1]], deck[selected[2]]) {
                    deck[selected[0]].isMatched = .ThreeAndSet
                    deck[selected[1]].isMatched = .ThreeAndSet
                    deck[selected[2]].isMatched = .ThreeAndSet
                    score += 2
                } else {
                    deck[selected[0]].isMatched = .ThreeNotSet
                    deck[selected[1]].isMatched = .ThreeNotSet
                    deck[selected[2]].isMatched = .ThreeNotSet
                    score -= 1
                }
            }
        }
    }
    
    private func compare3Cards(_ first: Card, _ second: Card, _ third: Card) -> Bool {
        if !compare3Content(first.content1, second.content1, third.content1) { return false }
        if !compare3Content(first.content2, second.content2, third.content2) { return false }
        if !compare3Content(first.content3, second.content3, third.content3) { return false }
        if !compare3Content(first.content4, second.content4, third.content4) { return false }
        return true
    }
    
    private func compare3Content<T>(_ first: T, _ second: T, _ third: T) -> Bool where T: Equatable {
        if !(first == second && first == third) && !(first != second && second != third && third != first) {
            return false
        } else {
            return true
        }
    }
    
    mutating func faceDown(_ card: Card) {
        if let index = deck.firstIndex(where: {$0.id == card.id}) {
            deck[index].isFaceUp = false
        }
    }
    
    mutating func faceUp(_ card: Card) {
        if let index = deck.firstIndex(where: {$0.id == card.id}) {
            deck[index].isFaceUp = true
        }
    }
    
    func answerExist() -> Bool {
        let cards = deck.filter({ $0.isDealt })
        for i in 0..<cards.count {
            for j in i+1..<cards.count {
                for k in j+1..<cards.count {
                    if compare3Cards(cards[i], cards[j], cards[k]) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    mutating func addCards() {
        if deckCount < 81 {
            deck[deckCount].isDealt = true
            deckCount += 1
            cardCount += 1
        }
    }
    
    mutating func add3Cards(penalty: Bool) {
        if deckCount < 81 {
            score += penalty ? -1 : 0
            addCards()
            addCards()
            addCards()
        }
    }
    
    mutating func addCardStart() {
        for _ in 0...11 {
            addCards()
        }
        isFirst = false
    }
    
    init(getProperty: (Int) -> (Content1, Content2, Content3, Content4)) {
        deck = [Card]()
        for i in 0...80 {
            let card = getProperty(i)
            deck.append(Card(content1: card.0, content2: card.1, content3: card.2, content4: card.3, id: i))
        }
        deck.shuffle()
    }
    
    struct Card: Identifiable {
        var isMatched: Success = .NotSelected
        var isFaceUp = false
        var isDealt = false
        var content1: Content1
        var content2: Content2
        var content3: Content3
        var content4: Content4
        var id: Int
    }
    
    enum Success {
        case ThreeAndSet, ThreeNotSet, Selected, NotSelected
    }
}

//extension Array {
//    var isOneOrTwo: (Element?, Element?) {
//        if self.count == 1 {
//            return (self[0], nil)
//        } else if self.count == 2 {
//            return (self[0], self[1])
//        } else {
//            return (nil, nil)
//        }
//    }
//}
