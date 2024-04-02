import SwiftUI

public struct StretchCat: View {
    @GestureState private var dragState = DragState.inactive
    @State private var isStretching = false
    @State private var emojiScale: CGFloat = 1.0
    
    public init() {}

    public var body: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 0.1)
            .onChanged { _ in
                isStretching = true
            }
            .onEnded { _ in
//                isStretching = false
            }

        let dragGesture = DragGesture()
            .updating($dragState) { value, state, _ in
                state = .dragging(translation: value.translation)
            }
            .onChanged { _ in
                
                emojiScale = 1.0 + abs(dragState.translation.height / 200)
            }
            .onEnded { _ in
                withAnimation {
                    emojiScale = 1.0
                    isStretching = false
                }
            }

        return Image(packageResource: isStretching ? "pop_cat_open" : "pop_cat_close", ofType: "png")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .scaleEffect(emojiScale)
            .gesture(longPressGesture.simultaneously(with: dragGesture))
            .offset(x: dragState.translation.width, y: dragState.translation.height)
    }
}


enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
}
