import Foundation

class ElementDetailViewModel: ObservableObject {
    let element: Element

    init(element: Element) {
        self.element = element
    }
}
