//
//  FilterNotesView.swift
//  NewNote
//
//  Created by Benji Loya on 24.02.2024.
//

/*
import SwiftUI
import SwiftData

enum SortOrder: LocalizedStringResource, Identifiable, CaseIterable {
    case title, subTitle
    
    var id: Self {
        self
    }
}

struct BookListView: View {
    @State private var createNewBook = false
    @State private var sortOrder = SortOrder.title
    @State private var filter = ""
    var body: some View {
        NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)")
                        .tag(sortOrder)
                }
            }
            .buttonStyle(.bordered)
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: Text("Search"))
                .navigationTitle("Just journal")
        }
    }
}

#Preview("English") {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return BookListView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
}

struct BookList: View {
    @Environment(\.modelContext) private var context
    @Query private var notes: [Note]
    init(sortOrder: SortOrder, filterString: String) {
        let sortDescriptors: [SortDescriptor<Note>] = switch sortOrder {
        case .title:
            [SortDescriptor(\Note.title)]
        case .subTitle:
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
        
        ScrollView(.vertical) {
            
            TipView(deleteNoteTip)
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                
                ForEach(notes) {
                    Card(note: $0)
                        .zIndex(10)
                }
                .padding(.top, 10)
                                    
            }
            .padding(.bottom, 65)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        
    }
}
*/
