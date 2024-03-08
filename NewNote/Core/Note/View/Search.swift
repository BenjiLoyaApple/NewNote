//
//  Search.swift
//  NewNote
//
//  Created by Benji Loya on 24.02.2024.
//

import SwiftUI
import SwiftData
import TipKit

enum SortOrder: LocalizedStringResource, Identifiable, CaseIterable {
    case Title, Description
    
    var id: Self {
        self
    }
}

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var sortOrder = SortOrder.Title
    @State private var searchText = ""
    var body: some View {
            NavigationStack {
                ScrollView(.vertical) {
                    
                    VStack {
                        SearchList(sortOrder: sortOrder, filterString: searchText)
                    }
                    .searchable(text: $searchText, prompt: Text("Search"))
                }
                .navigationTitle("Search")
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        // Close Button
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Close")
                                .foregroundStyle(.red)
                        })
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(SortOrder.allCases) { sortOrder in
                                Button(action: {
                                    self.sortOrder = sortOrder
                                    HapticManager.instance.impact(style: .soft)
                                }) {
                                    Text(sortOrder.rawValue)
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .foregroundStyle(.primary)
                        }
                    }
                    
                }
            }
            .accentColor(.primary)
        
    }
}

#Preview("English") {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return SearchView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
}


//MARK: - List
struct SearchList: View {
    @Query private var notes: [Note]
    
    @State private var searchText = ""
    
    init(sortOrder: SortOrder, filterString: String) {
        var sortDescriptors: [SortDescriptor<Note>]
        
        switch sortOrder {
        case .Title:
            sortDescriptors = [SortDescriptor(\Note.title)]
        case .Description:
            sortDescriptors = [SortDescriptor(\Note.subTitle)]
        }
        
        let predicate = #Predicate<Note> { note in
            note.title.localizedStandardContains(filterString)
                || note.subTitle.localizedStandardContains(filterString)
        //    || note.date
                || filterString.isEmpty
        }
        
        _notes = Query(filter: predicate, sort: sortDescriptors, animation: .snappy)
    }

    var body: some View {
        VStack(spacing: 10) {
            if notes.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .padding(.top, 270)
            } else {
                ForEach(notes) {
                    Card(note: $0)
                }
                .padding(.top, 10)
            }
        }
    }
}
