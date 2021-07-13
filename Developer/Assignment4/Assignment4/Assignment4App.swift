//
//  Assignment4App.swift
//  Assignment4
//
//  Created by 강현준 on 2021/07/09.
//

import SwiftUI

@main
struct Assignment4App: App {
    private let game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
