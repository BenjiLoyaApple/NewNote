//
//  NewHome.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct NewHome: View{
    ///Active Notes
    @Query(filter: #Predicate<Note> { !$0.isCompleted}, sort: [SortDescriptor(\Note.date, order: .reverse)], animation: .snappy) private var activeList: [Note]
    
    /// Model Context
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    @State private var addNote: Bool = false
    
    @State private var showAllBookmark: Bool = false
    /// Note Tip
    @State private var noteTip = NoteTip()
    @State private var deleteNoteTip = DeleteNoteTip()
     
    @State private var blurType: BlurType = .freeStyle
    
    @State var showBookmarkView: Bool = false
    @State var showSearchView: Bool = false
    
    var body: some View{
        let config = Config(
            leading: .init(name: "magnifyingglass", title: "Search"),
            center: .init(name: "arrow.counterclockwise", title: "Refresh"),
            trailing: .init(name: "bookmark", title: "Bookmark")
        )
        
        ChromeScrollView(config: config) {
            
            ScrollView(.vertical) {
                
                TipView(deleteNoteTip)
                    .padding(.horizontal)
                
                VStack {
                    Section {
                        ForEach(activeList) {
                            NoteCardView(note: $0)
                        }
                    } header: {
                        HStack {
    //                        Text("Active (\(activeSectionTitle.count))")
                            Text("Active")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                                .padding(.leading)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    /// Completed List
                    CompletedNoteList(showAll: $showAll)
                                        
                }
                .padding(.bottom, 65)
            }
            .scrollIndicators(.hidden)
            .sheet(isPresented: $addNote) {
                AddNotesView()
                  .interactiveDismissDisabled()
                  .onAppear {
                      Task { await DeleteNoteTip.deleteNoteVisitedEvent.donate()}
                  }
            }
            
        } navbar: {
            HStack(spacing: 0) {
                Text("Just Journal")
                    .font(.title.bold())
                
                Spacer()
            }
//            TextField("File Name", text: .constant(""))
//                .font(.callout)
//                .padding(.vertical,8)
//                .padding(.horizontal,15)
//                .background {
//                    Capsule()
//                        .fill(.thickMaterial)
//                }
//            .padding(.vertical,10)
            
        } leadingAction: {
            showSearchView.toggle()
        } centerAction: {
            
        } trailingAction: {
            showBookmarkView.toggle()
        }
        .sheet(isPresented: $showSearchView) {
         //   SearchView()
        }
        .sheet(isPresented: $showBookmarkView) {
            BookmarkNoteView(showAllFavorites: $showAllBookmark)
        }
        .overlay(alignment: .bottom) {
                HStack() {
                    // Add Note Button
                    Button {
                        addNote.toggle()
                        noteTip.invalidate(reason: .actionPerformed)
                        print("PRESS - Add Note")
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
                        .blur(radius: 5, opaque: blurType == .clipped)
                       
                }
                .offset(y: 50)
        }
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
