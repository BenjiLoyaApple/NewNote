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
    case title, description
    
    var id: Self {
        self
    }
}

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var sortOrder = SortOrder.title
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                
                SearchList(sortOrder: sortOrder, filterString: searchText)
                    .searchable(text: $searchText, prompt: Text("Search"))
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Search")
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
                    Picker("", selection: $sortOrder) {
                        ForEach(SortOrder.allCases) { sortOrder in
                            Text(sortOrder.rawValue)
                                .tag(sortOrder)
                        }
                    }
                    .buttonStyle(.automatic)
                }
                
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
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

struct SearchList: View {
    @Environment(\.modelContext) private var context
//    @Query private var notes: [Note]
    
    @Query(filter: #Predicate<Note> { !$0.isCompleted}, sort: [SortDescriptor(\Note.date, order: .reverse)], animation: .snappy) private var notes: [Note]
    
    init(sortOrder: SortOrder, filterString: String) {
        let sortDescriptors: [SortDescriptor<Note>] = switch sortOrder {
        case .title:
            [SortDescriptor(\Note.title)]
        case .description:
            [SortDescriptor(\Note.subTitle)]
        }
        let predicate = #Predicate<Note> { note in
            note.title.localizedStandardContains(filterString)
            || note.subTitle.localizedStandardContains(filterString)
            || filterString.isEmpty
        }
        _notes = Query(filter: predicate, sort: sortDescriptors)
    }
    
    var body: some View {
            LazyVStack(spacing: 10) {
                ForEach(notes) {
                    Card(note: $0)
                }
                .padding(.top, 10)
            }
    }
}
