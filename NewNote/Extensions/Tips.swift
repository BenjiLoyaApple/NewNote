//
//  Tips.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import Foundation
import TipKit

//MARK: - Add Note
struct NoteTip: Tip {
    var title: Text {
        Text("Add entry")
    }
    var message: Text? {
        Text("Create your first entry.")
    }
    var image: Image? {
        Image(systemName: "note.text")
    }
}

//MARK: - Delete Note
struct DeleteNoteTip: Tip {
    static let setDeleteNoteEvent = Event(id: "setDeleteNoteEvent")
    static let deleteNoteVisitedEvent = Event(id: "deleteNoteVisitedEvent")
    var title: Text {
        Text("Entry Actions")
    }
    var message: Text? {
        Text("Swipe down to see options")
    }
//    var image: Image? {
//        Image(systemName: "trash")
//    }
    
    var rules: [Rule] {
        #Rule(Self.setDeleteNoteEvent) { event in
            event.donations.count == 0
        }
        #Rule(Self.deleteNoteVisitedEvent) { event in
            event.donations.count > 2
        }
    }
}
