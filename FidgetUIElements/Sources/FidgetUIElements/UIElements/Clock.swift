import SwiftUI

public struct Clock: View {
    @State private var rotation: Double = 0 // Положение минутной стрелки в градусах
    @State private var currentTime: String = "" // Текущее время
    @State private var time: Int = 900
    
    public init() {}
    
    public var body: some View {
        VStack {
            ZStack {
                // Фоновый круг, представляющий циферблат часов
                Image(packageResource: "clock", ofType: "png")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .foregroundColor(.gray)
                
                // Минутная стрелка
                ArrowView(rotation: $rotation)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Получаем угол вращения и обновляем положение стрелки
                                let vector = CGVector(dx: value.location.x - 20, dy: value.location.y - 20)
                                let angle = atan2(vector.dy, vector.dx) * 180 / .pi
                                rotation = angle
                                DispatchQueue.main.async {
                                    updateClockTime(x: value.location.x, y: value.location.y)
                                }
                                
                            }
                    )
                
                // Электронные часы
                Text(currentTime)
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .offset(y: -200)
            }
        }
    }
    
    // Обновляем время на электронных часах
    private func updateClockTime(x: Double, y: Double) {
        time += 1
        
        let hour = time / 24 % 24
        let minute = time % 60
        
        currentTime = String(format: "%02d:%02d", hour, minute)
    }
}

// Представление минутной стрелки
struct ArrowView: View {
    @Binding var rotation: Double // Положение стрелки в градусах
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .offset(x: 1 , y: 35)
            .frame(width: 3, height: 80)
            .foregroundColor(.black)
            .rotationEffect(.degrees(rotation), anchor: .trailing)
    }
}
