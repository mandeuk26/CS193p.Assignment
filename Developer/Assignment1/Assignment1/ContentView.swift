//
//  ContentView.swift
//  Assignment1
//
//  Created by 강현준 on 2021/06/29.
//

import SwiftUI

struct ContentView: View {
    @State var emojis:[[String]] = [["🚗", "🚕", "🚙", "🚌", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜"], ["🐕", "🐏", "🐖", "🐂", "🦒", "🐘", "🦛", "🦭", "🐆", "🦓", "🐅", "🦏", "🐋"], ["🧕", "👮🏽‍♂️", "💂🏻‍♀️", "👷🏼", "👩🏿‍🍳", "👨🏻‍🌾", "👩🏾‍🏫", "🧑🏼‍🎤", "👨🏽‍🔧"]]
    @State var emojiSelect = 0
    @State var emojiCount = Int.random(in: 4...12)
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                    ForEach(emojis[emojiSelect][0..<emojiCount], id: \.self) {
                        CardView(image: $0).aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(.red)
            }
            Spacer()
            HStack {
                minus
                Spacer()
                Icon1
                Spacer()
                Icon2
                Spacer()
                Icon3
                Spacer()
                plus
            }
            .padding(.horizontal)
            
        }
        .padding(.horizontal)
    }
    var Icon1: some View {
        Button{
            emojiSelect = 0
            emojiCount = Int.random(in: 4...emojis[0].count)
            emojis[0].shuffle()
        } label: {
            let image = VStack {
                Image(systemName: "car")
                    .font(.largeTitle)
                Text("vehicle")
                    .font(.headline)
            }
            if emojiSelect == 0 {
                image.foregroundColor(.red)
            }
            else {
                image
            }
        }
    }
    var Icon2: some View {
        Button{
            emojiSelect = 1
            emojiCount = Int.random(in: 4...emojis[1].count)
            emojis[1].shuffle()
        } label: {
            let image = VStack {
                Image(systemName: "hare")
                    .font(.largeTitle)
                Text("animal")
                    .font(.headline)
            }
            if emojiSelect == 1 {
                image.foregroundColor(.red)
            }
            else {
                image
            }
        }
    }
    var Icon3: some View {
        Button{
            emojiSelect = 2
            emojiCount = Int.random(in: 4...emojis[2].count)
            emojis[2].shuffle()
        } label: {
            let image = VStack {
                Image(systemName: "person")
                    .font(.largeTitle)
                Text("human")
                    .font(.headline)
            }
            if emojiSelect == 2 {
                image.foregroundColor(.red)
            }
            else {
                image
            }
        }
    }
    
    var plus: some View {
        Button {
            if emojiCount < emojis[emojiSelect].count {
                emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
                .font(.title)
        }
    }
    
    var minus: some View {
        Button {
            if emojiCount > 4 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
                .font(.title)
        }
    }
}

struct CardView: View {
    var image: String
    @State var isOpen: Bool = false
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isOpen {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 5.0)
                Text(image).font(.largeTitle)
            }
            else {
                shape.fill()
            }
        }
        .onTapGesture {
            isOpen = !isOpen
        }
    }
    func makeClose() {
        isOpen = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
