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
    var tag: Tag = Tag.clear
    
//    init(title: String, subTitle: String, tag: Tag) {
//        self.title = title
//        self.subTitle = subTitle
//        self.tag = tag
//    }
    
    init(
        title: String,
        subTitle: String,
        date: Date = Date.now,
        image: Data? = nil,
        tag: Tag
    ) {
        self.title = title
        self.subTitle = subTitle
        self.date = date
        self.image = image
        self.tag = tag
    }
}

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
