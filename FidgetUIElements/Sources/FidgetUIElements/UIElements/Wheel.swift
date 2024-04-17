import SwiftUI

public struct Wheel: View {
    @State private var currentAngle: Angle = .degrees(0)
    @State private var result = ""
    @State private var isAnimating = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            ZStack {
                
                Sector(startAngle: .degrees(0), endAngle: .degrees(360))
                    .fill(Color.green)
                
                Sector(startAngle: .degrees(90), endAngle: .degrees(270))
                    .fill(Color.red)
                
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .rotationEffect(currentAngle, anchor: .center)
                    .offset(x: 0, y: -150) // Смещаем стрелку на край круга
                    .animation(isAnimating ? .linear(duration: 2) : .none)
                    .gesture(
                        TapGesture()
                            .onEnded {
                                let randomAngle = Double.random(in: 0...360)
                                currentAngle = .degrees(randomAngle)
                                isAnimating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    updateResult()
                                    isAnimating = false
                                }
                            }
                    )
                
                Text(result)
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
    
    func updateResult() {
        // неадекватная тригонометрическая окружность...
        if currentAngle.degrees >= 0 && currentAngle.degrees < 180 {
            result = "Да"
        } else {
            result = "Нет"
        }
    }
}

struct Sector: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}
