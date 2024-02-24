//
//  Search.swift
//  NewNote
//
//  Created by Benji Loya on 24.02.2024.
//

import SwiftUI
import SwiftData
import Combine


struct Search: View {
    
    /// Search
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    
    @State private var selectedTag: Tag? = nil
    let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        
//        TextField("Search", text: $searchText)
//            .font(.callout)
//            .padding(.vertical,8)
//            .padding(.horizontal,20)
//            .background {
//                Capsule()
//                    .fill(.gray.opacity(0.15))
//                    .stroke(ColorManager.plus.opacity(0.6), lineWidth: 0.6)
//            }
        
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack {
                    FilterNotesView(tag: selectedTag, searchText: filterText) { notes in
                            VStack(spacing: 10) {
                                
                                ForEach(notes) {
                                    Card(note: $0)
                                }
                                .padding(.top, 10)
                                                    
                            }
                    }
                }
            }
            .overlay(content: {
                ContentUnavailableView("Search Entires", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1 : 0)
            })
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty {
                    filterText = ""
                }
                searchPublisher.send(newValue)
            })
            
        }
        .searchable(text: $searchText)
        
        
    }
    
    
}

#Preview() {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return Search()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
        .padding(.horizontal)
}
