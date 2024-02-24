//
//  NewHome.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct Home: View {
    ///Active Notes
    @Query(filter: #Predicate<Note> { !$0.isCompleted}, sort: [SortDescriptor(\Note.date, order: .reverse)], animation: .snappy) private var activeList: [Note]
    /// Model Context
    @Environment(\.modelContext) private var context
    @State private var addNote: Bool = false
    /// Note Tip
    @State private var noteTip = NoteTip()
    @State private var deleteNoteTip = DeleteNoteTip()
    // Show Any view
    @State private var showBookmarkView: Bool = false
    @State private var showCompleteView: Bool = false
    /// Sheet
    @State private var showAll: Bool = false
    @State private var showAllBookmark: Bool = false
    /// Search
    @State private var searchText: String = ""
    
    var body: some View {
        let config = Config(
            leading: .init(name: "circle.badge.checkmark", title: "Completed"),
            center: .init(name: "arrow.counterclockwise", title: "Refresh"),
            trailing: .init(name: "bookmark", title: "Bookmark")
        )
        
        ChromeScrollView(config: config) {
            
            ScrollView(.vertical) {
                
                TipView(deleteNoteTip)
                    .padding(.horizontal)
                
                VStack(spacing: 10) {
                    
                    ForEach(activeList) {
                        Card(note: $0)
                    }
                    .padding(.top, 10)
                                        
                }
                .padding(.bottom, 65)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            
            .sheet(isPresented: $addNote) {
                //  Search()
                AddNotesView()
                  .interactiveDismissDisabled()
                  .onAppear {
                      Task { await DeleteNoteTip.deleteNoteVisitedEvent.donate()}
                  }
            }
               
        } navbar: {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("Just Journal")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .shadow(color: ColorManager.textColor.opacity(0.2), radius: 1, x: 2, y: 2)
                    
                    Spacer()
                }
                
           //    Search()
               //     .padding(.vertical,10)
            }
            .padding(.top, 10)
            
        } leadingAction: {
            showCompleteView.toggle()
        } centerAction: {
            // Refresh View
        } trailingAction: {
            showBookmarkView.toggle()
        }
        .scrollDismissesKeyboard(.interactively)
        
        .fullScreenCover(isPresented: $showCompleteView) {
            NavigationStack {
                CompletedNoteList(showAll: $showAll)
            }
        }
       
        .fullScreenCover(isPresented: $showBookmarkView) {
            NavigationStack {
                BookmarkNoteView(showAllBookmark: $showAllBookmark)
            }
        }
        
        .overlay(alignment: .bottom) {
            if searchText.isEmpty {
            HStack() {
                // Add Note Button
                Button {
                    addNote.toggle()
                    noteTip.invalidate(reason: .actionPerformed)
                    HapticManager.instance.impact(style: .medium)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 60))
                        .foregroundStyle(ColorManager.plus, ColorManager.circle.gradient)
                }
                .popoverTip(noteTip)
                .shadow(color: .black.opacity(0.25), radius: 15, x: 7, y: 10)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 40)
            .ignoresSafeArea(.all)
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 10)
                
            }
            .offset(y: 50)
            }
        }
        .background {
            HomeBG()
        }
//        .overlay {
//            if showBookmarkView {
//                withAnimation(.bouncy) {
//                    BookmarkNoteView(showAllBookmark: $showAllBookmark)
//                        .background(Color.white)
//                        .transition(.move(edge: .trailing))
//                }
//            }
//        }
        
    }
    
}

#Preview("English") {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return ContentView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
        .task {
        //    try? Tips.resetDatastore()
            /// Configure and load your tips at app launch.
            try? Tips.configure([
                // .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}

#Preview("Russian") {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return ContentView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "RU"))
        .task {
        //    try? Tips.resetDatastore()
            /// Configure and load your tips at app launch.
            try? Tips.configure([
                // .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
