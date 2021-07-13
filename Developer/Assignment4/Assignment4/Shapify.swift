//
//  Shapify.swift
//  Assignment4
//
//  Created by 강현준 on 2021/07/13.
//

import SwiftUI

struct Shapify: View {
    init(card: SetGameViewModel.Card) {
        color = card.content1.value()
        symbol = card.content2
        number = card.content3.value()
        shading = card.content4
    }
    
    var color: Color
    var symbol: SetGameViewModel.CardSymbol
    var number: Int
    var shading:SetGameViewModel.CardShading
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height/30) {
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                if number > 0 { makeSymbol().frame(height: geometry.size.height/4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).aspectRatio(shapifyConstant.imageRatio, contentMode: .fit) }
                if number > 1 { makeSymbol().frame(height: geometry.size.height/4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).aspectRatio(shapifyConstant.imageRatio, contentMode: .fit) }
                if number > 2 { makeSymbol().frame(height: geometry.size.height/4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).aspectRatio(shapifyConstant.imageRatio, contentMode: .fit) }
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    @ViewBuilder
    func makeSymbol() -> some View {
        Group {
            switch symbol {
            case .oval :
                Capsule().addShade(shading: shading, lineWidth: shapifyConstant.lineWidth, numberOfStrips: shapifyConstant.numberOfStrips)
            case .diamond : Diamond().addShade(shading: shading, lineWidth: shapifyConstant.lineWidth, numberOfStrips: shapifyConstant.numberOfStrips)
            case .squid : Squid().addShade(shading: shading, lineWidth: shapifyConstant.lineWidth, numberOfStrips: shapifyConstant.numberOfStrips)
            }
        }
        .foregroundColor(color)
    }
    
    private struct shapifyConstant {
        static let shapeAspect:CGFloat = 0.7
        static let lineWidth:CGFloat = 1.0
        static let numberOfStrips:Int = 5
        static let imageRatio:CGFloat = 2/1
    }
}


extension Shape {
    @ViewBuilder
    func addShade(shading: SetGameViewModel.CardShading, lineWidth: CGFloat, numberOfStrips: Int) -> some View {
        switch shading {
        case .solid :
            ZStack {
                self.fill()
                self.stroke(lineWidth: lineWidth)
            }
        case .open :
            self.stroke(lineWidth: lineWidth)
        case .striped :
            self.striped(numberOfStrips: numberOfStrips, borderLineWidth: lineWidth)
        }
    }
    
    @ViewBuilder
    func striped(numberOfStrips: Int, borderLineWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<numberOfStrips) { number in
                Color.white
                Rectangle()
                if number == numberOfStrips - 1 {
                    Color.white
                }
            }
            
        }
        .mask(self)
        .overlay(self.stroke(lineWidth: borderLineWidth))
    }
}
