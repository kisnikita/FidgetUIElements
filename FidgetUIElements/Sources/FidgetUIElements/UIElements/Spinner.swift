import SwiftUI

public struct Spinner: View {
    @State private var angle: Double = 0
    @State private var acceleration: Double = 0
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)

    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    let colors: [Color]
        
    public init(colors: [Color]) {
        self.colors = colors
    }

    public var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: self.colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .mask(
                        Image(packageResource: "spinner", ofType: "png")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(angle * 0.25))
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.startLocation.x < geometry.size.width / 2 {
                                    acceleration -= value.translation.height / 10
                                } else {
                                    acceleration += value.translation.height / 10
                                }
                            }
                    )
                    .onReceive(timer) { _ in
                        acceleration -= (acceleration * 0.01)
                        angle += acceleration

                        feedbackGenerator.impactOccurred()
                    }
                }
            }
        }
    }
}
