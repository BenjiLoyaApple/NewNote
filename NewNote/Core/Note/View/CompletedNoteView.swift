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
        _completedList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }
        
    var body: some View {
        
        if !completedList.isEmpty {
            VStack(spacing: 20) {
                
                HStack(spacing: 0) {
                    Text("Completed")
                        .font(.title3.bold())
                    
                    Spacer()
                }
                .padding(.leading, 15)
                
                ForEach(completedList) {
                    Card(note: $0)
                }
            }
            .padding(.top)
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
