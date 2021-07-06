//
//  Assignment2App.swift
//  Assignment2
//
//  Created by 강현준 on 2021/06/30.
//

import SwiftUI

@main
struct Assignment2App: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
