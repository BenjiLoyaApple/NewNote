//
//  FavoritesNoteView.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

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
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
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

#Preview {
    ContentView()
}
