//
//  Cardify.swift
//  Assignment4
//
//  Created by 강현준 on 2021/07/09.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: CardConstant.cornerRaius)
        ZStack {
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: CardConstant.cardBorderSize)
            } else {
                shape.fill().foregroundColor(CardConstant.cardBackColor)
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
        .padding(CardConstant.paddingSize)
    }
    
    private struct CardConstant {
        static let cornerRaius: CGFloat = 5
        static let cardBorderSize: CGFloat = 2
        static let cardBackColor: Color = .red
        static let paddingSize: CGFloat = 4
    }
}
