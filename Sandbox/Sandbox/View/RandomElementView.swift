import SwiftUI

struct RandomElementView: View {
    @ObservedObject var viewModel: RandomElementViewModel
    
    var body: some View {
        VStack {
            if let randomElement = viewModel.randomElement {
                ElementDetailView(viewModel: ElementDetailViewModel(element: randomElement))
                    .padding()
            } else {
                Text("No random element selected")
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                viewModel.pickRandomElement()
            }) {
                Text("Pick Random Element")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}
