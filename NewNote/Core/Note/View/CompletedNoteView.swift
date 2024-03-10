//
//  CompletedNoteView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData

struct CompletedNoteList: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var showAll: Bool
    @Query private var completedList: [Note]
    init(showAll: Binding<Bool>) {
        let predicate = #Predicate<Note> { $0.isCompleted }
        let sort = [SortDescriptor(\Note.date, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll.wrappedValue {
            /// Limiting to 10
            descriptor.fetchLimit = 10
        }
        _completedList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }
        
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                if completedList.isEmpty {
                    VStack {
                        Spacer(minLength: 290)
                        ContentUnavailableView("Completed is empty", systemImage: "circle.badge.checkmark", description: Text("Entires will appear here"))
                    }
                } else {
                    Section {
                        ForEach(completedList) {
                            Card(note: $0)
                                .padding(.vertical, 5)
                        }
                    } header: {
                        HStack {
                            Spacer()
                            if showAll && !completedList.isEmpty {
                                Button("Show Recents") {
                                    showAll = false
                                }
                                .foregroundColor(.primary)
                            }
                        }
                        .font(.caption)
                        .padding(.horizontal)
                        .padding(.top, 5)
                    } footer: {
                        if completedList.count == 10 && !showAll && !completedList.isEmpty {
                            HStack {
                                Text("Showing Recent 10")
                                    .foregroundStyle(.secondary)
                                
                                Spacer(minLength: 0)
                                
                                Button("Show All") {
                                    showAll = true
                                }
                                .foregroundColor(.primary)
                            }
                            .font(.caption)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationTitle("Completed")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    // Close
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Close")
                            .foregroundStyle(.red)
                    })
                }
            }
        }
        
        
//        if !completedList.isEmpty {
//            VStack(spacing: 20) {
//                
//                HStack(spacing: 0) {
//                    Text("Completed")
//                        .font(.title3.bold())
//                    
//                    Spacer()
//                }
//                .padding(.leading, 15)
//                
//                ForEach(completedList) {
//                    Card(note: $0)
//                }
//            }
//            .padding(.top)
//        }
    }
}

#Preview("English") {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return CompletedNoteList(showAll: .constant(true))
  //  return ContentView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
}


/*
 import SwiftUI
 import SwiftData

 struct CompletedNoteList: View {
     
     @Environment(\.dismiss) private var dismiss
     
     @Binding var showAll: Bool
     @Query private var completedList: [Note]
     init(showAll: Binding<Bool>) {
         let predicate = #Predicate<Note> { $0.isCompleted }
         let sort = [SortDescriptor(\Note.date, order: .reverse)]
         
         var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
         _completedList = Query(descriptor, animation: .snappy)
         _showAll = showAll
     }
         
     var body: some View {
         ScrollView(.vertical, showsIndicators: false) {
             if completedList.isEmpty {
                 VStack {
                     Spacer(minLength: 290)
                     ContentUnavailableView("Comleted is empty", systemImage: "circle.badge.checkmark",
                     description: nil)
                 }
             } else {
                 VStack(spacing: 20) {
                     ForEach(completedList) {
                         Card(note: $0)
                     }
                 }
                 .padding(.top, 10)
             }
         }
               .navigationTitle("Completed")
               .toolbar {
                   ToolbarItem(placement: .topBarLeading) {
                       // Close
                       Button(action: {
                          dismiss()
                       }, label: {
                           Text("Close")
                               .foregroundStyle(.red)
                       })
                   }
                   
               }
         
     }
 }

 #Preview("English") {
     let preview = Preview(Note.self)
     let notes = Note.sampleNotes
     preview.addExamples(notes)
     return CompletedNoteList(showAll: .constant(true))
   //  return ContentView()
         .modelContainer(preview.container)
         .environment(\.locale, Locale(identifier: "EN"))
 }
 */
