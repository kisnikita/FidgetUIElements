import SwiftUI
import Combine

public struct Tapper: View {
    @State private var count: Int = 0
    @State private var tapLocation: CGPoint? = nil
    @GestureState private var isTapping = false
    @State private var target: Int = 10
    @State private var isConfettiActive = false
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($isTapping) { value, state, _ in
                            state = true
                            tapLocation = value.location
                        }
                        .onEnded { _ in
                            count += 1
                            feedbackGenerator.impactOccurred()
                        }
                )
            
            if let location = tapLocation {
                Circle()
                    .stroke(LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                    .frame(width: 50, height: 50)
                    .position(location)
                    .scaleEffect(isTapping ? 2 : 0.5)
                    .opacity(isTapping ? 1 : 0)
                    .animation(.easeInOut(duration: 0.75))
            }
            
            VStack {
                Text("\(count)")
                    .font(.system(size: 100))
                    .padding()
                Spacer()
                
                Text("Target: \(target)")
                    .font(.system(size: 25))
                    .padding()
            }
        }
        .onReceive(Just(count)) { _ in
            if count >= target {
                target *= 2
                isConfettiActive = true
                DispatchQueue.main.async {
                    playSound("confetti_sound")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isConfettiActive = false
                }
            }
        }
        .background(
            ConfettiView(isActive: $isConfettiActive)
        )
    }
}

public struct ConfettiView: View {
    @Binding var isActive: Bool
    
    public var body: some View {
        if isActive {
            GeometryReader { geometry in
                ForEach(0..<100) { _ in
                    ConfettiPiece(geometry: geometry)
                }
            }
            .onDisappear {
                isActive = false
            }
        }
    }
}

public struct ConfettiPiece: View {
    let geometry: GeometryProxy
    @State private var xOffset: CGFloat = .random(in: 0...500)
    @State private var yOffset: CGFloat = .random(in: 0...500)
    @State private var rotation = Angle(degrees: .random(in: 0...360))
    
    public var body: some View {
        let position = CGPoint(x: xOffset, y: yOffset)
        
        Circle()
            .fill(Color.purple)
            .frame(width: 10, height: 10)
            .offset(x: position.x, y: position.y)
            .rotationEffect(rotation)
            .animation(.easeInOut(duration: 3))
            .onAppear {
                animate()
            }
    }
    
    func animate() {
        xOffset = .random(in: -geometry.size.width...geometry.size.width)
        yOffset = .random(in: -geometry.size.height...geometry.size.height)
        rotation = Angle(degrees: .random(in: 0...360))
    }
}
