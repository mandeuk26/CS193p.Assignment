//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 강현준 on 2021/06/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var dealingNamespace
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) {
                CardView(card: $0)
                    .matchedGeometryEffect(id: $0.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: $0))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 5)) {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let totalDealDuration: Double = 2
        static let dealDuration: Double = 0.5
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}

//preview를 컨트롤하는 코드
//위에서 선언한 ContentView를 불러온다는 것을 명심하자.

//Property Observers
//저장된 값이 변경될때마다 특정 동작을 수행하도록 설정할 수 있음
//computed variable과 다르다는 것을 명심!
//실제로 어딘가에 저장된 값이라는점!
//var isFaceUp: Bool {
//  willSet {
//      if newValue {
//          startUsingBonusTime()
//      } else {
//          stopUsingBounusTime()
//      }
//  }
//}



//animation
//ViewModifier를 사용하면 간편함 -> protocol의 일종

//ViewModifier
//View를 만드는 것과 비슷함
//Text("Something").modifier(Cardify(isFaceUp: true)) -> 실제로 ViewModifier를 사용하는 법
//struct Cardify: ViewModifier {
//    var isFaceUp: Bool
//    func body(content: Content) -> some View {
//        <#code#>
//    }
//}
//놀랍게도 body가 여기서는 func의 형태라는 것을 명심하자.
//이 때 isFaceUp과 같은 argument를 활용해서 내부 코드를 작성할 수 있는데
//ViewModifier에서는 argument가 crucial하다. 왜냐? 이 값이 변하면 에니메이션이 작동하기 때문에

//이 때 다음과 같이 정의하면 코드를 좀 더 간결하게 표현할 수 있다.
//Text("Something").cardify(isFaceUp: true)
//extension View {
//    func cardify(isFaceUp: Bool) -> some View {
//        return self.modifier(Cardify(isFaceUp: isFaceUp))
//    }
//}

//ViewModifier를 정의하면 우리는 원하는 View에 대해서 .modifier 속성을 적용시켜 어떤 View가 오던지
//동일하게 주변 환경을 꾸며줄 수 있다.

//animation
//무언가가 바뀌어야만 에니메이션이 작동함
//ViewModifier arguments
//Shape
//The existence (or not) of a View in the UI
//따라서 Shape 내부나 ViewModifier 내부에서만 에니메이션 정의를 한다.
//변화는 먼저 일어나고 그거를 천천히 보여주는 것이다.

//ViewModifier에 따라 animatable 여부가 다름 (ex font는 animatable 하지않음)
//ViewModifier argument에 대한 change는 해당 View가 UI에 들어간 후에만 일어나야한다는 점을 명심하자!
//예를들어 특정 View가 생성되고 사라지는 animation을 넣고싶다면 해당 View가 들어가는 Container가 이미 UI에 존재해있어야한다.

//1. automatically : .animation(Animation)
//Text("👻")
//    .opacity(scary ? 1 : 0)
//    .rotationEffect(Angle.degrees(upsideDown ? 180 : 0))
//    .animation(Animation.eraseInOut)
//놀랍게도 scary와 upsideDown 값이 바뀔때마다 자동으로 eraseInOut 애니메이션이 작동된다.
//한가지 유의할 점은 설정한 속성들은 .animation은 본인 이전에 선언된 ViewModifier에게만 작용한다는 점이다.
//2. Explicitly : withAnimation(Animation) { }
//withAnimation(.linear(duration: 2)) {
//    //do somthing that will cause ViewModifier/Shape arguments to change somewhere
//}
//3. Transitions : By making Views be included or excluded from the UI
//View의 arrival/departure를 정의함
//CTAAOS (Containers That Are Already On-Screen) 안에 있는 View에 대해서만 동작
//pre-canned tansition 목록들이 있음 -> 모두 AnyTransition struct에 존재
//ZStack {
//    if isFaceUp {
//        RoundedRectangle(cornerRadius: 10).stroke()
//        Text("👻").transition(AnyTransition.scale)
//    } else {
//        RoundedRectangle(cornerRadius: 10).transition(AnyTransition.identity)
//    }
//}
//automatically 의 경우 외부 ZStack에 animation을 적용하면 단순히 내부의 View들에게 각각 적용하는 형태였지만
//Transition의 경우는 Stack 자체에 적용이되어서 Stack내부의 모든 View가 동시에 사라지고 나타나는 형태이다.
//transition은 사라지고 나타날때 어떤 동작을 취할 것인지를 정했을 뿐 실제로 에니메이션을 작동시키지는 않는다.
//.transition(AnyTransition.opacity.anumation(.linear(duration: 20))) 와 같이 사용해야한다.
//만약 하나의 container 에서 다른 container로 위치를 바꾸고 싶다면 양쪽 모두 동일한 View를 넣어준다.
//그 후 .matchedGeometryEffect(id: ID, in: Namespace) 와 같이 사용한다.
//이 때 Namespace는 @Namespace private var myNamespace와 같이 정의하는데 두 container의 view는 동일한 id를 갖기때문에 이름으로 구분해준다.


//.onAppear { }
//View가 등장했을때 바로 특정 animation을 동작하고 싶을때 사용함 (.onDisappear { } 도 있다는 것을 명심)

//이제 viewmodifier가 animatable 하다는 것을 알려주기 위해서는 var animatableData: Type(Dont care)를 가져야한다.
//이 때 animatableData는 VectoArithmetic 해야하며 AnimatablePair를 가질수도있다.


//Animation struct
//duration, delay, repeat 를 설정할 수 있음
//Animation Curve
//애니메이션의 속도 템포를 조절할 수 있음
//.linear : 균일하게, .eraseInOut : 처음과 끝은 느리게 중간은 균일하게, .spring : 끝날때쯤 살짝 shoot해서 spring처럼 돌아오게함
 
