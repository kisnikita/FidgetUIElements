import Foundation
import SwiftUI

struct Element: Identifiable { // Добавляем протокол Identifiable
    let id = UUID() 
    var view: AnyView
    let name: String
    // Добавьте свойства, соответствующие вашим элементам
}
