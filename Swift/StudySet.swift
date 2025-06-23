import Foundation
import SwiftData

@Model
final class StudySet: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var terms: [Term]

    init(id: UUID = UUID(), title: String, description: String, terms: [Term] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.terms = terms
    }
}

@Model
final class Term: Identifiable {
    let id: UUID
    var word: String
    var definition: String

    init(id: UUID = UUID(), word: String, definition: String) {
        self.id = id
        self.word = word
        self.definition = definition
    }
}
