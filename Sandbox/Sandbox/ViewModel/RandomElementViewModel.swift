import Foundation

class RandomElementViewModel: ObservableObject {
    @Published var randomElement: Element?
    private var elements: [Element] = [] // Здесь хранятся все элементы
    
    init(elements: [Element]) {
        self.elements = elements
    }
    
    func pickRandomElement() {
        // Выбираем случайный элемент из списка
        randomElement = elements.randomElement()
    }
}
