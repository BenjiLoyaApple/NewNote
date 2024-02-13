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
        SwipeAction(cornerRadius: 15, direction: .trailing) {
            
            CardView(note: note)
            
        } actions: {
            /// Complete
            Action(tint: ColorManager.bgColor, icon: note.isCompleted ? "checkmark.circle.fill" : "checkmark.circle.fill", iconTint: note.isCompleted ? .green : .mint) {
                print("Complete note")
                
                withAnimation {
                    note.isCompleted.toggle()
                    note.date = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            /// Edit
            Action(tint: ColorManager.bgColor, icon: "pencil.circle.fill", iconTint: .blue) {
                print("Edit note")
                showEditView.toggle()
                WidgetCenter.shared.reloadAllTimelines()
            }
            /// Delete
            Action(tint: ColorManager.bgColor, icon: "trash.circle.fill", iconTint: .red) {
                print("Delete note")
                withAnimation {
                    context.delete(note)
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
                ///In app Toast
                //                Toast.shared.present(
                //                    title: "Deleted",
                //                    symbol: "xmark.circle",
                //                    tintSymbol: Color.red,
                //                    isUserInteractionEnabled: true,
                //                    timing: .medium
                //                )
            }
        }
        
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = note.title.isEmpty
        }
        .onSubmit(of: .text) {
            if note.title.isEmpty {
                /// Deleting Empty Todo
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
        }
        .fullScreenCover(isPresented: $showEditView) {
            EditNoteView(note: note)
        }
        
    }
    
}

#Preview {
    let preview = Preview(Note.self)
    return  NavigationStack {
        NoteCardView(note: Note.sampleNotes[1])
            .modelContainer(preview.container)
    }
}



