//
//  EmojiMemoryGame.swift
//  Assignment2
//
//  Created by ๊ฐํ์ค on 2021/06/30.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static var emojis:[[String]] = [["๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐"],
                                    ["โฝ๏ธ", "๐", "๐", "โพ๏ธ", "๐ฅ", "๐พ", "๐", "๐", "๐ฅ", "๐ฑ"],
                                    ["๐ถ", "๐ญ", "๐น", "๐ฐ", "๐ฆ", "๐ป", "๐ผ", "๐ปโโ๏ธ", "๐จ", "๐ฏ", "๐ฆ", "๐ฎ", "๐ท"],
                                    ["๐", "๐", "๐", "๐", "๐", "๐ซ", "๐ง ", "๐ซ"],
                                    ["๐ณ๐ฟ", "๐ณ๐บ", "๐ณ๐ช", "๐ฐ๐ท", "๐ฑ๐ท", "๐ฉ๐ช", "๐ณ๐ซ", "๐ฌ๐น", "๐ฒ๐ฌ"],
                                    ["โค๏ธ", "๐งก", "๐", "๐", "๐", "๐", "๐ค", "๐ค"]]
    
    private var model = MemoryGame<String>()
    
    var score: Int {
        model.score
    }
    
    var themeColor: Color {
        if let index = model.themeIndex {
            switch model.theme[index].color {
            case "Pink": return .pink
            case "Red": return .red
            case "Blue": return .blue
            case "Yellow": return .yellow
            case "Purple": return .purple
            case "Orange": return .orange
            default: return .black
            }
        }
        else {
            return .black
        }
    }
    
    var themeName: String {
        if let index = model.themeIndex {
            return model.theme[index].name
        } else {
            return ""
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    init() {
        addTheme(name: "Vehicle", emojis: EmojiMemoryGame.emojis[0], pairs: Int.random(in: 4...EmojiMemoryGame.emojis[0].count), color: "Red")
        addTheme(name: "Ball", emojis: EmojiMemoryGame.emojis[1], pairs: Int.random(in: 4...EmojiMemoryGame.emojis[1].count), color: "Blue")
        addTheme(name: "Animal", emojis: EmojiMemoryGame.emojis[2], pairs: Int.random(in: 4...EmojiMemoryGame.emojis[2].count), color: "Yellow")
        addTheme(name: "Body", emojis: EmojiMemoryGame.emojis[3], pairs: Int.random(in: 4...EmojiMemoryGame.emojis[3].count), color: "Purple")
        addTheme(name: "Flag", emojis: EmojiMemoryGame.emojis[4], pairs: Int.random(in: 4...EmojiMemoryGame.emojis[4].count), color: "Orange")
        addTheme(name: "Heart", emojis: EmojiMemoryGame.emojis[5], pairs: Int.random(in: 4...EmojiMemoryGame.emojis[5].count), color: "Pink")
    }
    
    func addTheme(name: String, emojis: [String], pairs: Int, color: String) {
        model.addTheme(name: name, emojis: emojis, pairs: pairs, color: color)
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        objectWillChange.send()
        model.choose(card)
    }
    
    func reset() {
        objectWillChange.send()
        model.reset()
    }
}
