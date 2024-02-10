//
//  NoteRowView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import WidgetKit

struct TodoRowView: View {
    
    @Bindable var note: Note
    /// View Properties
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    var body: some View {
        HStack(spacing: 8) {
            if !isActive && !note.title.isEmpty {
                Button(action: {
                    note.isCompleted.toggle()
                    note.date = .now
              //      WidgetCenter.shared.reloadAllTimelines()
                }, label: {
                Image(systemName: note.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .padding(3)
                    .contentShape(.rect)
                    .foregroundStyle(note.isCompleted ? .gray : .accentColor)
                    .contentTransition(.symbolEffect(.replace))
            })
        }
            
            TextField("Write task", text: $note.title)
                .strikethrough(note.isCompleted)
                .foregroundStyle(note.isCompleted ? .gray : .primary)
                .focused($isActive)
            
            if !isActive && !note.title.isEmpty {
                /// Priority Menu Button (For Updating)
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue) { priority in
                        Button(action: { note.priority = priority }, label: {
                            HStack {
                                Text(priority.rawValue)
                                
                                if note.priority == priority { Image(systemName: "checkmark") }
                            }
                        })
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .containerShape(.rect)
                        .foregroundStyle(note.priority.color.gradient)
                }
            }
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = note.title.isEmpty
        }
        /// Swipe to delete
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                context.delete(note)
             //   WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        }
        .onSubmit(of: .text) {
            if note.title.isEmpty {
                /// Deleting Empty Todo
                context.delete(note)
          //      WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && note.title.isEmpty {
                context.delete(note)
          //      WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            note.isCompleted = note.isCompleted
        }
    }
}

#Preview {
    ContentView()
}
