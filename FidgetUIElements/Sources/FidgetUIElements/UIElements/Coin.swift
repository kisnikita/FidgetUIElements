import SwiftUI

public struct Coin: View {
    @State private var isHeads = true
    @State private var headsCount = 0
    @State private var tailsCount = 0
    @State private var coinOffset: CGSize = .zero
    @State private var rotationAngle: Double = 0
    @State private var isAnimating = false
    @State private var isDisabled = false
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    public init() {}
    
    public var body: some View {
        let coinimage = isHeads ? "coin_head" : "coin_tail"
        VStack {
            Text("Heads: \(headsCount)")
            Text("Tails: \(tailsCount)")
            Spacer()
            Image(packageResource: coinimage, ofType: "png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(rotationAngle))
                .offset(coinOffset)
                .animation(nil)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            guard !isDisabled else { return }
                            flipCoin()
                            withAnimation(.easeInOut(duration: 0.7)) {
                                rotationAngle += 360
                                isAnimating.toggle()
                            }
                            playSound("coin_flipp")
                            isDisabled = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                isDisabled = false
                            }
                        }
                )
                .rotation3DEffect(
                    .degrees(isAnimating ? 1800 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
            Spacer()
            
            Button(action: {
                headsCount = 0
                tailsCount = 0
            }) {
                Text("Reset")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.brown)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    func flipCoin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isHeads = Bool.random()
            if isHeads {
                headsCount += 1
            } else {
                tailsCount += 1
            }
            feedbackGenerator.impactOccurred()
        }
    }
}
