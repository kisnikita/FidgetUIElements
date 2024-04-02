import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    viewModel.navigateToRandomElement()
                }) {
                    Text("Random Element")
                }
                List(viewModel.elements) { element in
                    NavigationLink(destination: ElementDetailView(viewModel: ElementDetailViewModel(element: element))) {
                        Text(element.name)
                    }
                }
            }
            .navigationTitle("Fidget Elements")
        }
    }
}
