import SwiftUI

enum RabbitState {
    case sit, stand, jump, sleep
}

public struct Rabbit: View {
    @State private var state: RabbitState = .sit
    @State private var lastChangeTime: Date?
    @State private var isPunched = false
    
    public init() {}

    public var body: some View {
        Image(packageResource: imageName(for: state), ofType: "png")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 250)
            .rotationEffect(.degrees(isPunched ? randomAngle() : 0), anchor: .center)
            .offset(y: isPunched ? -200 : 0)
            .animation(.easeInOut(duration: 0.05))
            .onTapGesture {
                handleTap()
            }
            .onChange(of: state) { _ in
                lastChangeTime = Date()
            }
            .onReceive(timer) { _ in
                checkAutoTransition()
            }
            .transition(.identity)
            .animation(.spring())
    }
    
    private func handleTap() {
        switch state {
        case .sit:
            state = .stand
        case .stand:
            isPunched = true
            state = .jump
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isPunched = false
                state = .stand
            }
        case .jump:
            break
        case .sleep:
            state = .sit
        }
    }
    
    private func checkAutoTransition() {
        guard let lastChangeTime = lastChangeTime else { return }
        let now = Date()
        let timeSinceLastChange = now.timeIntervalSince(lastChangeTime)
        
        switch state {
        case .sit:
            if timeSinceLastChange > 5 {
                state = .sleep
            }
        case .stand:
            if timeSinceLastChange > 2 {
                state = .sit
            }
        case .jump:
            break
        case .sleep:
            break
        }
    }
    
    private func imageName(for state: RabbitState) -> String {
        switch state {
        case .sit: return "sit_rabbit"
        case .stand: return "stand_rabbit"
        case .jump: return "jump_rabbit"
        case .sleep: return "sleep_rabbit"
        }
    }
    
    private func randomAngle() -> Double {
        return Double.random(in: -45...45)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

