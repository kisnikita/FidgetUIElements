import SwiftUI
import Combine

public struct Magnet: View {
    @State private var balls: [Ball2] = []
    @State private var magnetPosition: CGPoint = .zero
    @State private var isDraggingMagnet = false
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(balls) { filing in
                    Circle()
                        .fill(Color.indigo)
                        .frame(width: 10, height: 10)
                        .position(filing.position)
                }
                
                Image(packageResource: "magnet", ofType: "png")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .position(magnetPosition)
                    .onAppear {
                        magnetPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                magnetPosition = value.location
                                isDraggingMagnet = true
                                balls.removeAll()
                            }
                            .onEnded { _ in
                                isDraggingMagnet = false
                            }
                    )
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDraggingMagnet {
                            creatBall(position: value.location)
                        }
                    }
            )
        }
        .onReceive(ballsTimer) { _ in
            updateBallsPosition()
        }
    }
    
    private func creatBall(position: CGPoint) {
        balls.append(Ball2(position: position))
    }
    
    private func updateBallsPosition() {
        for index in balls.indices {
            var filing = balls[index]
            let distanceX = magnetPosition.x - filing.position.x
            let distanceY = magnetPosition.y - filing.position.y
            
            filing.position.x += distanceX * 0.05
            filing.position.y += distanceY * 0.05
            
            balls[index] = filing
        }
    }
    
    private var ballsTimer: AnyPublisher<Date, Never> {
        Timer.publish(every: 0.00, on: .main, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
    }
}

struct Ball2: Identifiable {
    let id = UUID()
    var position: CGPoint
}
