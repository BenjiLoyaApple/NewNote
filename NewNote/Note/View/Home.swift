//
//  Home.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    ///Active Todo's
    @Query(filter: #Predicate<Note> { !$0.isCompleted}, sort: [SortDescriptor(\Note.date, order: .reverse)], animation: .snappy) private var activeList: [Note]
    
    /// Model Context
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    var body: some View {
        List {
            Section(activeSectionTitle) {
                ForEach(activeList) {
                    TodoRowView(note: $0)
                }
            }
            
            /// Completed List
            CompletedTodoList(showAll: $showAll)
            
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    /// Creating an Empty Todo Task
                    let note = Note(title: "", priority: .normal)
                    /// Saving item into context
                    context.insert(note)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 41))
                })
            }
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active (\(count))"
    }
    
}

#Preview {
    ContentView()
}
