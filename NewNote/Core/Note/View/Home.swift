//
//  Home.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct Home: View {
    ///Active Notes
    @Query(filter: #Predicate<Note> { !$0.isCompleted}, sort: [SortDescriptor(\Note.date, order: .reverse)], animation: .snappy) private var activeList: [Note]
    
    /// Model Context
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    @State private var addNote: Bool = false
    
    /// Note Tip
    @State private var noteTip = NoteTip()
    @State private var deleteNoteTip = DeleteNoteTip()
    
    var body: some View {
        ScrollView(.vertical) {
            
            TipView(deleteNoteTip)
                .padding(.horizontal)
            
            VStack {
                Section {
                    ForEach(activeList) {
                        NoteCardView(note: $0)
                    }
                } header: {
                    HStack {
//                        Text("Active (\(activeSectionTitle.count))")
                        Text("Active")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                            .padding(.leading)
                        
                        Spacer(minLength: 0)
                    }
                }
                /// Completed List
                CompletedNoteList(showAll: $showAll)
                
            }
        }
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    addNote.toggle()
                    noteTip.invalidate(reason: .actionPerformed)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 41))
                }
                .popoverTip(noteTip)
                .sensoryFeedback(.start, trigger: addNote)
            }
        }
        .sheet(isPresented: $addNote) {
            AddNotesView()
              .interactiveDismissDisabled()
              .onAppear {
                  Task { await DeleteNoteTip.deleteNoteVisitedEvent.donate()}
              }
            
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active (\(count))"
    }
    
}

#Preview("English") {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return Home()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
        .task {
            try? Tips.resetDatastore()
            /// Configure and load your tips at app launch.
            try? Tips.configure([
                // .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
