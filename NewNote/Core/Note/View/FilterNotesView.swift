//
//  FilterNotesView.swift
//  NewNote
//
//  Created by Benji Loya on 24.02.2024.
//

import SwiftUI
import SwiftData

struct FilterNotesView<Content: View>: View {
    var content: ([Note]) -> Content
    
    @Query(animation: .snappy) private var notes: [Note]
    init(tag: Tag?, searchText: String, @ViewBuilder content: @escaping ([Note]) -> Content) {
        /// Custom Predicate
        
        let rawValue = tag?.rawValue ?? ""
        let predicate = #Predicate<Note> { note in
            return note.title.localizedStandardContains(searchText) ||
            note.subTitle.localizedStandardContains(searchText)
        }
        
        _notes = Query(filter: predicate, sort: [
            SortDescriptor(\Note.date, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
    }
    
    
    var body: some View {
        content(notes)
    }
}
