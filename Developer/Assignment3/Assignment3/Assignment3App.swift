//
//  Assignment3App.swift
//  Assignment3
//
//  Created by 강현준 on 2021/07/05.
//

import SwiftUI

@main
struct Assignment3App: App {
    private let game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
