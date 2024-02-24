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
        //  NavigationStack {
              ScrollView(.vertical, showsIndicators: false) {
                  VStack(spacing: 20) {
                      ForEach(completedList) {
                          Card(note: $0)
                      }
                      }
                      .padding(.top, 10)
                  }
          //    }
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
        
        
        
        
        
//        VStack(spacing: 20) {
//            HStack {
//                Text("Completed")
//                    .font(.title.bold())
//                    .foregroundStyle(.primary)
//                    .padding(.leading)
//                    .padding(.top)
//                
//                Spacer()
//            }
//            
//            ScrollView(.vertical) {
//                ForEach(completedList) {
//                    Card(note: $0)
//                }
//                .padding(.top, 10)
//            }
//            .scrollIndicators(.hidden)
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
     
     @Binding var showAll: Bool
     @Query private var completedList: [Note]
     init(showAll: Binding<Bool>) {
         let predicate = #Predicate<Note> { $0.isCompleted }
         let sort = [SortDescriptor(\Note.date, order: .reverse)]
         
         var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
         if !showAll.wrappedValue {
             /// Limiting to 15
             descriptor.fetchLimit = 15
         }
         _completedList = Query(descriptor, animation: .snappy)
         _showAll = showAll
     }
         
     var body: some View {
         Section {
             ForEach(completedList) {
              //   NoteRowView(note: $0)
                 NoteCardView(note: $0)
             }
         } header: {
             HStack {
                 Text("Completed")
                     .font(.subheadline.bold())
                     .foregroundStyle(.secondary)
                     .padding(.leading)
                     .padding(.top)
                 
                 Spacer(minLength: 0)
                 
                 if showAll && !completedList.isEmpty {
                     Button("Show Recents") {
                         showAll = false
                     }
                 }
             }
             .font(.caption)
         } footer: {
             if completedList.count == 15 && !showAll && !completedList.isEmpty {
                 HStack {
                     Text("Showing Recent 15 Entires")
                         .foregroundStyle(.gray)
                     
                     Spacer(minLength: 0)
                     
                     Button("Show All") {
                         showAll = true
                     }
                 }
                 .font(.callout)
                 .padding()
             }
         }
     }
 }

 #Preview {
     ContentView()
 }

 */
