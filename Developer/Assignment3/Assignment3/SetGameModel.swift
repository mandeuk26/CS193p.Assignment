//
//  SetGameModel.swift
//  Assignment3
//
//  Created by 강현준 on 2021/07/05.
//

import Foundation

struct SetGame<Content1, Content2, Content3, Content4> where Content1: Equatable, Content2: Equatable, Content3: Equatable, Content4: Equatable{
    private var deck:[Card]
    private(set) var cards = [Card]()
    private(set) var score = 0
    private var deckCount = 0
    private var matchedNumber: (Int?, Int?) {
        get { cards.indices.filter({ cards[$0].isMatched == .Selected }).isOneOrTwo }
        set { cards.indices.forEach{ cards[$0].isMatched = ($0 == newValue.0 || $0 == newValue.1) ? .Selected : .NotSelected } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { card.id == $0.id }) {
            if cards[chosenIndex].isMatched != .Selected {
                let tempMatchedNumber = matchedNumber
                if let firstIndex = tempMatchedNumber.0, let secondIndex = tempMatchedNumber.1 {
                    var state:Success = .ThreeNotSet
                    if compare3Cards(cards[firstIndex], cards[secondIndex], cards[chosenIndex]) {
                        state = .ThreeAndSet
                        score += 2
                    } else {
                        score -= 1
                    }
                    cards[firstIndex].isMatched = state
                    cards[secondIndex].isMatched = state
                    cards[chosenIndex].isMatched = state
                } else if let firstIndex = tempMatchedNumber.0 {
                    matchedNumber = (firstIndex, chosenIndex)
                } else {
                    let eraseList = cards.indices.filter({ cards[$0].isMatched == .ThreeAndSet })
                    var amountOfMove = 0
                    if eraseList.count == 3 {
                        if cards.count == 12 && deckCount < 81 {
                            for index in eraseList {
                                cards[index] = deck[deckCount]
                                deckCount += 1
                            }
                        } else {
                            for index in eraseList.sorted(by: {$0 > $1}) {
                                cards.remove(at: index)
                                if index < chosenIndex { amountOfMove += 1 }
                            }
                        }
                        if eraseList.contains(chosenIndex) { return }
                    }
                    matchedNumber = (chosenIndex - amountOfMove, nil)
                }
            } else {
                cards[chosenIndex].isMatched = .NotSelected
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
    
    func answerExist() -> Bool {
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
            cards.append(deck[deckCount])
            deckCount += 1
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
    
    mutating func reset() {
        deck.shuffle()
        score = 0
        deckCount = 0
        cards = [Card]()
        for _ in 0...11 {
            addCards()
        }
    }
    
    init(getProperty: (Int) -> (Content1, Content2, Content3, Content4)) {
        deck = [Card]()
        for i in 0...80 {
            let card = getProperty(i)
            deck.append(Card(content1: card.0, content2: card.1, content3: card.2, content4: card.3, id: i))
        }
        reset()
    }
    
    struct Card: Identifiable {
        var isMatched: Success = .NotSelected
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

extension Array {
    var isOneOrTwo: (Element?, Element?) {
        if self.count == 1 {
            return (self[0], nil)
        } else if self.count == 2 {
            return (self[0], self[1])
        } else {
            return (nil, nil)
        }
    }
}
