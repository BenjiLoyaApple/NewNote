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
    var title: String
    var isCompleted: Bool = false
    var priority: Priority = Priority.normal
    var date: Date = Date.now
    
    init(title: String, priority: Priority) {
        self.title = title
        self.priority = priority
    }
}

// Priority Status
enum Priority: String, Codable, CaseIterable {
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    ///Priority Color
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}
