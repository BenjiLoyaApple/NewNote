//
//  NewHome.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct Home: View{
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
            leading: .init(name: "circle.badge.checkmark", title: "Completed"),
            center: .init(name: "arrow.counterclockwise", title: "Refresh"),
            trailing: .init(name: "bookmark", title: "Bookmark")
        )
        
        ChromeScrollView(config: config) {
            
            ScrollView(.vertical) {
                
                TipView(deleteNoteTip)
                    .padding(.horizontal)
                
                VStack {
                    
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
                        .font(.title.bold())
                    
                    Spacer()
                }
                
                TextField("Search", text: .constant(""))
                    .font(.callout)
                    .padding(.vertical,8)
                    .padding(.horizontal,15)
                    .background {
                        Capsule()
                            .fill(.gray.opacity(0.1))
                        
                    }
                    .padding(.vertical,10)
            }
            
        } leadingAction: {
            showSearchView.toggle()
        } centerAction: {
            // Refresh View
        } trailingAction: {
            showBookmarkView.toggle()
        }
        .scrollDismissesKeyboard(.interactively)
        .sheet(isPresented: $showSearchView) {
            CompletedNoteList(showAll: $showAll)
        }
        .sheet(isPresented: $showBookmarkView) {
            BookmarkNoteView(showAllBookmark: $showAllBookmark)
        }
        .overlay(alignment: .bottom) {
                HStack() {
                    // Add Note Button
                    Button {
                        addNote.toggle()
                        noteTip.invalidate(reason: .actionPerformed)
                        HapticManager.instance.impact(style: .medium)
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
        
        .background {
            ZStack {
                Circle()
                    .fill(
                        .linearGradient(colors: [
                            .teal.opacity(0.08),
                            .indigo.opacity(0.15)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 150, height: 150)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: -25, y: 150)
                
                Circle()
                    .fill(
                        .linearGradient(colors: [
                            .orange.opacity(0.2),
                            .pink.opacity(0.15)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 180, height: 180)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: 25, y: -25)
            }
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

/// Blur State
enum BlurType: String, CaseIterable {
    case clipped = "Clipped"
    case freeStyle = "Free Style"
}
