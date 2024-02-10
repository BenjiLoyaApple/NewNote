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
//    var tag: Tag = Tag.clear
    var tag: Tag?
    
    init(
        title: String,
        subTitle: String,
        date: Date = Date.now,
        image: Data? = nil,
//        tag: Tag
        tag: Tag? = nil
    ) {
        self.title = title
        self.subTitle = subTitle
        self.date = date
        self.image = image
        self.tag = tag
    }
}

/*
// Priority Status
enum Tag: String, Codable, CaseIterable {
    case clear = "Empty"
    case yellow = "Yellow"
    case orange = "Orange"
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    case purple = "Purple"
    case gray = "Gray"
    case personal = "Personal"
    case work = "Work"
    case important = "Important"
    
    ///Priority Color
    var color: Color {
        switch self {
        case .clear:
            return Color.gray.opacity(0.15)
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
            return Color.mint // You can replace this with the desired color
        case .work:
            return Color.indigo // You can replace this with the desired color
        case .important:
            return Color.teal // You can replace this with the desired color
        }
    }
}
*/

enum Tag: String, Codable, Identifiable, CaseIterable {
    case yellow, orange, red, green, blue, purple, gray, personal, work,  important

    var id: Self {
        self
    }

    var name: LocalizedStringKey {
        switch self {
//        case .clear:
//            return "Empty"
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
//        case .clear:
//            return Color.clear
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

