import SwiftUI

public struct Lamp: View {
    @State private var selectedColors: [[Color]] = Array(repeating: Array(repeating: Color.gray, count: 4), count: 4)
    
    public init() {}
    
    public var body: some View {
        VStack {
            LampShape()
                .fill(getCombinedColor())
                .overlay(LampShape().stroke(Color.black, lineWidth: 2))
                .frame(width: 200, height: 200)
            
            VStack {
                ForEach(0..<4) { row in
                    HStack {
                        ForEach(0..<4) { column in
                            Button(action: {
                                self.toggleColor(row, column)
                                DispatchQueue.main.async {
                                    playSound("light_click")
                                }
                            }) {
                                Circle()
                                    .fill(self.selectedColors[row][column])
                                    .frame(width: 30, height: 30)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private func toggleColor(_ row: Int, _ column: Int) {
        var colors = selectedColors
        colors[row][column] = colors[row][column] == Color.gray ? getRandomColor() : Color.gray
        selectedColors = colors
    }
    
    private func getCombinedColor() -> Color {
        var red: Double = 0
        var green: Double = 0
        var blue: Double = 0
        
        for row in selectedColors {
            for color in row {
                let components = color.components()
                red += components.red
                green += components.green
                blue += components.blue
            }
        }
        
        let count = Double(selectedColors.count * selectedColors[0].count)
        red /= count
        green /= count
        blue /= count
        
        return Color(red: red, green: green, blue: blue)
    }
    
    private func getRandomColor() -> Color {
        let randomRed = Double.random(in: 0...1)
        let randomGreen = Double.random(in: 0...1)
        let randomBlue = Double.random(in: 0...1)
        return Color(red: randomRed, green: randomGreen, blue: randomBlue)
    }
}

struct LampShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

extension Color {
    func components() -> (red: Double, green: Double, blue: Double) {
        guard let components = UIColor(self).cgColor.components else { return (0, 0, 0) }
        return (Double(components[0]), Double(components[1]), Double(components[2]))
    }
}
