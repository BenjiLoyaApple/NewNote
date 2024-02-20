//
//  NoteCardView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import WidgetKit

struct NoteCardView: View {
    @Bindable var note: Note
    /// View Properties
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    
    @State private var showEditView: Bool = false
    
    init(note: Note) {
        _note = Bindable(note)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image
               ImageCard(note: note)
                .padding(.horizontal, 3)
            
            VStack(alignment: .leading, spacing: 6) {
                // Text
                TextCard(note: note)
                
                ButtonCard(note: note)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding(10)
        }
        .padding(.top, 3)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(14)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = note.title.isEmpty
        }
        .onSubmit(of: .text) {
            if note.title.isEmpty {
                /// Deleting Empty Note
                context.delete(note)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && note.title.isEmpty {
                context.delete(note)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            note.isCompleted = note.isCompleted
            note.isfavorite = note.isfavorite
        }
        .task {
            
        }
//        .fullScreenCover(isPresented: $showEditView) {
//            EditNoteView(note: note)
//        }
    }
}

#Preview {
    let preview = Preview(Note.self)
    return  NavigationStack {
        NoteCardView(note: Note.sampleNotes[1])
            .modelContainer(preview.container)
    }
}
