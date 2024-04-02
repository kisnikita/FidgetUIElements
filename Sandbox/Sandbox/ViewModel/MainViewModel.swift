import Foundation
import SwiftUI
import FidgetUIElements

class MainViewModel: ObservableObject {
    @Published var elements: [Element] = [
        Element(view: AnyView(MemCat()), name: "MemCat"),
        Element(view: AnyView(Rabbit()), name: "Rabbit"),
        Element(view: AnyView(Coin()), name: "Coin"),
        Element(view: AnyView(Molecules()), name: "Molecules"),
        Element(view: AnyView(Rain()), name: "Rain"),
        Element(view: AnyView(Spinner(colors: [.blue, .green, .pink])), name: "Spinner"),
        Element(view: AnyView(StretchCat()), name: "StretchCat"),
        Element(view: AnyView(Magnet()), name: "Magnet"),
        Element(view: AnyView(Tapper()), name: "Tapper"),
        Element(view: AnyView(Tapper()), name: "Glass"),
        Element(view: AnyView(Tapper()), name: "Tapper"),
        Element(view: AnyView(Tapper()), name: "Tapper"),
        Element(view: AnyView(Tapper()), name: "Tapper"),
        Element(view: AnyView(Tapper()), name: "Tapper"),
        Element(view: AnyView(Tapper()), name: "Tapper"),
        Element(view: AnyView(Tapper()), name: "Tapper"),
    ]
    
    func navigateToRandomElement() {
        // Навигация к случайному элементу
    }
}
