//
//  SetGameViewModel.swift
//  Assignment4
//
//  Created by 강현준 on 2021/07/09.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGame<CardColor, CardSymbol, CardNumber, CardShading>.Card

    private static var CardSet = SetGameViewModel.makeCardSet()
    
    private static func makeCardSet() -> [(CardColor, CardSymbol, CardNumber, CardShading)] {
        var tmp = [(CardColor, CardSymbol, CardNumber, CardShading)]()
        for color in CardColor.order {
            for symbol in CardSymbol.order {
                for number in CardNumber.order {
                    for shading in CardShading.order {
                        tmp.append((color, symbol, number, shading))
                    }
                }
            }
        }
        return tmp
    }
    
    private static func makeSetGame() -> SetGame<CardColor, CardSymbol, CardNumber, CardShading> {
        SetGame<CardColor, CardSymbol, CardNumber, CardShading> { CardSet[$0] }
    }
    
    @Published private var model = makeSetGame()
    
    var deck: Array<Card> {
        model.deck
    }

    var score: Int {
        model.score
    }
    
    var isFirst: Bool {
        model.isFirst
    }
    
    var cardCount: Int {
        model.cardCount
    }
    
    var deckCount: Int {
        model.deckCount
    }
    
    func addCardStart() {
        model.addCardStart()
    }
    
    func answerExist() -> Bool {
        model.answerExist()
    }
    
    func add3Card(penalty: Bool = false) {
        model.add3Cards(penalty: penalty)
    }
    
    func reset() {
        model = SetGameViewModel.makeSetGame()
    }
    
    func faceUp(_ card: Card) {
        model.faceUp(card)
    }
    
    func faceDown(_ card: Card) {
        model.faceDown(card)
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    

    enum CardColor {
        case red, purple, green
        static let order = [red, purple, green]
        func value() -> Color {
            switch self {
            case .red    : return .red
            case .purple : return .purple
            case .green  : return .green
            }
        }
    }
    enum CardSymbol {
        case oval, diamond, squid
        static let order = [oval, diamond, squid]
    }
    enum CardNumber {
        case one, two, three
        static let order = [one, two, three]
        func value() -> Int {
            switch self {
            case .one    : return 1
            case .two : return 2
            case .three  : return 3
            }
        }
    }
    enum CardShading {
        case solid, striped, open
        static let order = [solid, striped, open]
    }
}
