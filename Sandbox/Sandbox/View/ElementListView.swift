import SwiftUI

struct ElementListView: View {
    var elements: [Element]

    var body: some View {
        List(elements) { element in
            Text(element.name)
        }
    }
}
