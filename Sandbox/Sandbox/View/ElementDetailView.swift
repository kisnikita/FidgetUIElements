import SwiftUI

struct ElementDetailView: View {
    @ObservedObject var viewModel: ElementDetailViewModel

    var body: some View {
        VStack {
            viewModel.element.view
        }
        .navigationTitle(viewModel.element.name)
    }
}
