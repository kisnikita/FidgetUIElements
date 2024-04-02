import SwiftUI

public struct Molecules: View {
    @State private var isTouched = false
    @State private var molecules: [Molecule] = []
    @GestureState private var dragOffset: CGSize = .zero
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    molecules = []
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onChanged { value in
                            isTouched = true
                            let location = CGPoint(x: value.location.x + dragOffset.width, y: value.location.y + dragOffset.height)
                            let molecule = Molecule(x: location.x, y: location.y)
                            molecules.append(molecule)
                        }
                        .onEnded { _ in
                            isTouched = false
                        }
                )
            
            ForEach($molecules) { molecule in
                MoleculParticleView(molecule: molecule, isTouched: $isTouched)
            }
            
            VStack {
                Spacer()
                Button(action: {
                    molecules.removeAll()
                }) {
                    Text("Remove All")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

struct Molecule: Identifiable {
    var id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color = .random
}

struct MoleculParticleView: View {
    @Binding var molecule: Molecule
    @Binding var isTouched: Bool
    
    var body: some View {
        VStack {
            ForEach(0..<5) { _ in
                Circle()
                    .foregroundColor(molecule.color)
                    .frame(width: 10, height: 10)
                    .offset(x: randomOffset(), y: randomOffset())
                    .animation(Animation.linear(duration: .random(in: 0.5...1)).repeatForever(autoreverses: true))
                    .onAppear {
                        DispatchQueue.main.async {
                            molecule.color = Color.random
                        }
                    }
            }
        }
        .position(x: molecule.x, y: molecule.y)
    }
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

extension CGRect {
    var randomPoint: CGPoint {
        return CGPoint(x: CGFloat.random(in: minX..<maxX), y: CGFloat.random(in: minY..<maxY))
    }
}

func randomOffset() -> CGFloat {
    return CGFloat.random(in: -50...50)
}
