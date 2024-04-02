import SwiftUI

public struct Rain: View {
    @State private var raindrops: [CGPoint] = []
    @State private var isBrokenStates: [Bool] = []
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(raindrops.indices, id: \.self) { index in
                    if isBrokenStates[index] {
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 30, height: 3)
                            .position(raindrops[index])
                    } else {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 20)
                            .position(raindrops[index])
                            .onAppear {
                                moveRaindrop(at: index, height: geometry.size.height)
                            }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.black)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged{ value in
                        addRaindrop(at: value.location)
                    }
            )
        }
    }
    
    private func addRaindrop(at position: CGPoint) {
        raindrops.append(position)
        isBrokenStates.append(false)
    }
    
    private func moveRaindrop(at index: Int, height: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            var updatedRaindrop = raindrops[index]
            updatedRaindrop.y += 7
            
            if updatedRaindrop.y > height{
                isBrokenStates[index] = true
            } else {
                raindrops[index] = updatedRaindrop
                moveRaindrop(at: index, height: height)
            }
        }
    }
    
    
    public func setRaindrops(raindrops: [CGPoint]) {
        self.raindrops = raindrops
    }
    
    public func getRaindrops() -> [CGPoint] {
        return raindrops
    }
    
    public func setIsBrokenStates(isBrokenStates: [Bool]) {
        self.isBrokenStates = isBrokenStates
    }
    
    public func getIsBrokenStates() -> [Bool] {
        return isBrokenStates
    }
    
}
