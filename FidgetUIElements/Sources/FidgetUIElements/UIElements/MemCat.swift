import SwiftUI

public struct MemCat: View {
    @State private var isImageTapped = false
    private var openImage = "pop_cat_open"
    private var closeImage = "pop_cat_close"
    private var touchSound = "pop_sound"
    private var holdSound = "bruh_sound"
    
    public init() {}
    
    public var body: some View {
        let imageName = isImageTapped ? openImage : closeImage
        
        VStack{
            Spacer()
            
            Image(packageResource: imageName, ofType: "png")
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    isImageTapped.toggle()
                    playSound(touchSound)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
                        isImageTapped.toggle()
                    }
                }
                .gesture(LongPressGesture(minimumDuration: 0.01)
                    .onEnded { _ in
                        isImageTapped.toggle()
                        playSound(holdSound)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isImageTapped.toggle()
                        }
                    })
            
            Spacer()
        }
    }
}

struct CatPreview: PreviewProvider {
    static var previews: some View {
        MemCat()
    }
}
