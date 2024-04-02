import SwiftUI

struct ElementDetailView: View {
    @ObservedObject var viewModel: ElementDetailViewModel

    var body: some View {
        VStack {
            Text(viewModel.element.name)
            viewModel.element.view
            // Добавьте другие подробности о вашем элементе
        }
        .navigationTitle(viewModel.element.name)
    }
}
