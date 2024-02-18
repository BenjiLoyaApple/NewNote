//
//  Home.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct Home: View {
    ///Active Notes
    @Query(filter: #Predicate<Note> { !$0.isCompleted}, sort: [SortDescriptor(\Note.date, order: .reverse)], animation: .snappy) private var activeList: [Note]
    
    /// Model Context
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    @State private var addNote: Bool = false
    
    /// Note Tip
    @State private var noteTip = NoteTip()
    @State private var deleteNoteTip = DeleteNoteTip()
     
    @State private var blurType: BlurType = .freeStyle
    
    var body: some View {
        ScrollView(.vertical) {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 15, opaque: blurType == .clipped)
//                .padding([.horizontal, .top], -30)
//                .frame(height: 50 + safeArea.top)
                .visualEffect { view, proxy in
                    view
                        .offset(y: (proxy.bounds(of: .scrollView)?.maxY ?? 0))
                }
                /// Placing it above all the Views
                .zIndex(1000)
            
            
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
        }
        .scrollIndicators(.hidden)
        .toolbar {
            /// Sort Notes
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // sort action
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title3)
                        .fontWeight(.light)
                }
            }
        }
        .sheet(isPresented: $addNote) {
            AddNotesView()
              .interactiveDismissDisabled()
              .onAppear {
                  Task { await DeleteNoteTip.deleteNoteVisitedEvent.donate()}
              }
        }
        .overlay(alignment: .bottom) {
                HStack() {
                    // Add Note Button
                    Button {
                        addNote.toggle()
                        noteTip.invalidate(reason: .actionPerformed)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .fontWeight(.light)
                            .font(.system(size: 60))
                            .foregroundStyle(ColorManager.plus, ColorManager.circle.gradient)
                    }
                    .popoverTip(noteTip)
                    .shadow(radius: 10)
                    
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
//        .overlay {
//            if activeList.isEmpty {
//                ContentUnavailableView {
//                    Label("No Entries", systemImage: "tray.fill")
//                        .frame(width: 200)
//                }
//            }
//        }
        
        
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active (\(count))"
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
