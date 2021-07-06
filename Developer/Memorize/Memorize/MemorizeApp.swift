//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 강현준 on 2021/06/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
