//
//  FavoritesNoteView.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI
import SwiftData

struct FavoritesNoteView: View {
    
    @Binding var showAll: Bool
    @Query private var favoriteList: [Note]
    init(showAll: Binding<Bool>) {
        let predicate = #Predicate<Note> { $0.isfavorite }
        let sort = [SortDescriptor(\Note.date, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll.wrappedValue {
            /// Limiting to 15
            descriptor.fetchLimit = 15
        }
        _favoriteList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }
        
    var body: some View {
        Section {
            ForEach(favoriteList) {
                NoteCardView(note: $0)
            }
        } header: {
            HStack {
                Text("Favorites")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                    .padding(.top)
                
                Spacer(minLength: 0)
                
                if showAll && !favoriteList.isEmpty {
                    Button("Show Recents") {
                        showAll = false
                    }
                }
            }
            .font(.caption)
        } footer: {
            if favoriteList.count == 15 && !showAll && !favoriteList.isEmpty {
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
