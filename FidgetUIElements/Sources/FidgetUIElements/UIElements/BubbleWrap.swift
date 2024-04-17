import SwiftUI

public struct BubbleWrap: View {
    @State private var bubbles: [Bubble] = Array(repeating: Bubble(), count: 25)
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    public init() {}
    
    public var body: some View {
        VStack {
            ForEach(0..<5) { row in
                HStack {
                    ForEach(0..<5) { column in
                        BubbleView(bubble: self.$bubbles[row * 5 + column])
                            .onTapGesture {
                                self.bubblePopped(at: row * 5 + column)
                            }
                    }
                }
            }
        }
    }
    
    func bubblePopped(at index: Int) {
        if !bubbles[index].popped {
            bubbles[index].popped.toggle()
            playBubbleSoundAndVibration()
            if bubbles.allSatisfy({ $0.popped }) {
                resetBubbles()
            }
        }
    }
    
    func resetBubbles() {
        bubbles = Array(repeating: Bubble(), count: 25)
    }
    
    func playBubbleSoundAndVibration() {
        DispatchQueue.main.async {
            playSound("bubble")
        }
        feedbackGenerator.impactOccurred()
        
    }
}

struct BubbleView: View {
    @Binding var bubble: Bubble
    
    var body: some View {
        Image(systemName: bubble.popped ? "circle" : "circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(bubble.popped ? .clear : .blue)
            .opacity(0.4)
            .frame(width: 50, height: 50)
            .padding(5)
    }
}

struct Bubble {
    var popped = false
}
