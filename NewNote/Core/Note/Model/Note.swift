//
//  Note.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData

@Model
class Note {
    private(set) var noteID: String = UUID().uuidString
    var title: String = ""
    var subTitle: String = ""
    var date: Date = Date.now
    var image: Data?
    var isCompleted: Bool = false
    var tag: Tag?
    var isfavorite: Bool = false
    
    init(
        title: String,
        subTitle: String,
        date: Date = Date.now,
        image: Data? = nil,
        tag: Tag? = nil,
        isfavorite: Bool = false
    ) {
        self.title = title
        self.subTitle = subTitle
        self.date = date
        self.image = image
        self.tag = tag
        self.isfavorite = isfavorite
    }
}


enum Tag: String, Codable, Identifiable, CaseIterable {
    case yellow, orange, red, green, blue, purple, gray, personal, work,  important

    var id: Self {
        self
    }

    var name: LocalizedStringKey {
        switch self {
        case .yellow:
            return "Yellow"
        case .orange:
            return "Orange"
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .gray:
            return "Gray"
        case .personal:
            return "Personal"
        case .work:
            return "Work"
        case .important:
            return "Important"
        }
    }

    var color: Color {
        switch self {
        case .yellow:
            return Color.yellow
        case .orange:
            return Color.orange
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .purple:
            return Color.purple
        case .gray:
            return Color.gray
        case .personal:
            return Color.mint
        case .work:
            return Color.indigo
        case .important:
            return Color.teal
        }
    }
}
