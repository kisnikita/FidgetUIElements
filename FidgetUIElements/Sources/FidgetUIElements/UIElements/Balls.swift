import SwiftUI

public struct Balls: View {
    @State private var balls: [Ball3] = []
    @State private var holePosition: CGPoint = .zero
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(balls.indices, id: \.self) { index in
                    BallView(ball: balls[index])
                        .onAppear {
                            balls[index].startMoving(in: geometry.size, balls: balls, holePosition: holePosition)
                        }
                }
                HoleView(position: holePosition)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let location = value.location
                        if geometry.frame(in: .local).contains(location) {
                            let ball = Ball3(position: location)
                            balls.append(ball)
                        }
                    }
            )
            .onAppear {
                holePosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height)
            }
        }
    }
}

struct BallView: View {
    @ObservedObject var ball: Ball3
    
    var body: some View {
        Circle()
            .foregroundColor(Color.blue)
            .frame(width: ball.size, height: ball.size)
            .position(ball.position)
    }
}

struct HoleView: View {
    let position: CGPoint
    
    var body: some View {
        Rectangle()
            .stroke(Color.black, lineWidth: 2)
            .background(.blue)
            .frame(width: 100, height: 100)
            .position(position)
    }
}

class Ball3: ObservableObject, Equatable {
    static func == (lhs: Ball3, rhs: Ball3) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    @Published var position: CGPoint = .zero
    @Published var velocity: CGVector = .zero
    let size: CGFloat = 30
    
    init(position: CGPoint) {
        self.position = position
        self.velocity = CGVector(dx: CGFloat.random(in: -2...2), dy: CGFloat.random(in: -2...2))
    }
    
    func startMoving(in frame: CGSize, balls: [Ball3], holePosition: CGPoint) {
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            self.move(in: frame, balls: balls, holePosition: holePosition)
        }
    }
    
    func move(in frame: CGSize, balls: [Ball3], holePosition: CGPoint) {
        position.x += velocity.dx
        position.y += velocity.dy
        
        if position.x <= size / 2 || position.x >= frame.width - size / 2 {
            velocity.dx *= -1
        }
        if position.y <= size / 2 || position.y >= frame.height - size / 2 {
            velocity.dy *= -1
        }
        
        // Отталкивание от краёв экрана
        for ball in balls {
            if ball.id != self.id {
                let distance = sqrt(pow(ball.position.x - self.position.x, 2) + pow(ball.position.y - self.position.y, 2))
                if distance < (self.size + ball.size) / 2 {
                    let angle = atan2(ball.position.y - self.position.y, ball.position.x - self.position.x)
                    self.velocity.dx -= cos(angle) * 0.1
                    self.velocity.dy -= sin(angle) * 0.1
                }
            }
        }
        
        if isInHole(position: holePosition) {
            self.position = CGPoint(x: -1000, y: -1000)
        }
    }
    
    func isInHole(position: CGPoint) -> Bool {
        let distance = sqrt(pow(position.x - self.position.x, 2) + pow(position.y - self.position.y, 2))
        return distance < (self.size * 2)
    }
}
