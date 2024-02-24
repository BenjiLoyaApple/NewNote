//
//  FavoritesNoteView.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI
import SwiftData

struct BookmarkNoteView: View {
    
    @Environment(\.dismiss) private var dismiss

    @Binding var showAllBookmark: Bool
    @Query private var bookmarkList: [Note]
    
    init(showAllBookmark: Binding<Bool>) {
        let predicate = #Predicate<Note> { $0.isfavorite }
        let sort = [SortDescriptor(\Note.date, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        _bookmarkList = Query(descriptor, animation: .snappy)
        _showAllBookmark = showAllBookmark
    }
    
    var body: some View {
      //  NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(bookmarkList) {
                        Card(note: $0)
                    }
                    }
                    .padding(.top, 10)
                }
        //    }
            .navigationTitle("Bookmark")
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
//                Text("Bookmark")
//                    .font(.title.bold())
//                    .foregroundStyle(.primary)
//                    .padding(.leading)
//                    .padding(.top)
//                
//                Spacer()
//            }
//            
//            ScrollView(.vertical) {
//                ForEach(favoriteList) {
//                    Card(note: $0)
//                        .padding(.bottom, 10)
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
    return BookmarkNoteView(showAllBookmark: .constant(true))
  //  return ContentView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
}


/*
 import SwiftUI
 import SwiftData

 struct BookmarkNoteView: View {
     
     @Binding var showAllBookmark: Bool
     @Query private var favoriteList: [Note]
     init(showAllFavorites: Binding<Bool>) {
         let predicate = #Predicate<Note> { $0.isfavorite }
         let sort = [SortDescriptor(\Note.date, order: .reverse)]
         
         var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
         if !showAllFavorites.wrappedValue {
             /// Limiting to 15
             descriptor.fetchLimit = 15
         }
         _favoriteList = Query(descriptor, animation: .snappy)
         _showAllBookmark = showAllFavorites
     }
     
     var body: some View {
         ScrollView(.vertical) {
             Section {
                 ForEach(favoriteList) {
                     NoteCardView(note: $0)
                 }
             } header: {
                 HStack {
                     Text("Bookmark")
                         .font(.title.bold())
                         .foregroundStyle(.primary)
                         .padding(.leading)
                         .padding(.top)
                     
                     Spacer(minLength: 0)
                     
                     if showAllBookmark && !favoriteList.isEmpty {
                         Button("Show Recents") {
                             showAllBookmark = false
                         }
                     }
                 }
                 .font(.caption)
                 Divider()
             } footer: {
                 if favoriteList.count == 15 && !showAllBookmark && !favoriteList.isEmpty {
                     HStack {
                         Text("Showing Recent 15 Entires")
                             .foregroundStyle(.gray)
                         
                         Spacer(minLength: 0)
                         
                         Button("Show All") {
                             showAllBookmark = true
                         }
                     }
                     .font(.callout)
                     .padding()
                 }
             }
         }
         .scrollIndicators(.hidden)
     }
 }

 #Preview("English") {
     let preview = Preview(Note.self)
     let notes = Note.sampleNotes
     preview.addExamples(notes)
     return BookmarkNoteView(showAllFavorites: .constant(true))
   //  return ContentView()
         .modelContainer(preview.container)
         .environment(\.locale, Locale(identifier: "EN"))
 }
 */
