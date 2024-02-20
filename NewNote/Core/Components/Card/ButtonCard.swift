//
//  ButtonCard.swift
//  NewNote
//
//  Created by Benji Loya on 19.02.2024.
//

import SwiftUI
import WidgetKit

struct ButtonCard: View {
    @Bindable var note: Note
    @Environment(\.modelContext) private var context
    /// View Properties
    @State private var showEditView: Bool = false
    @State private var animateSymbol: Bool = false
    
    // Date Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter }()
    
    var body: some View {
        HStack(spacing: 25) {
            // Tag
            HStack(spacing: 5) {
                if let tag = note.tag {
                    Image(systemName: "circle.fill")
                        .frame(height: 10)
                        .padding(3)
                        .containerShape(.rect)
                        .foregroundStyle(tag.color.gradient)
                    
                    Text(tag.name)
                }
            }
            
            Spacer()
            
            
            //MARK: - Buttons
            HStack(spacing: 22) {
                /// Completed
                Button {
                    withAnimation {
                        note.isCompleted.toggle()
                        if note.isCompleted {
                            note.isfavorite = false
                        }
                        note.date = .now
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    print("PRESS - Completed")
                } label: {
                    Image(systemName: note.isCompleted ? "checkmark.circle.badge.xmark" : "checkmark.circle")
                        .foregroundStyle(note.isCompleted ? .green : .gray)
                }
                
                /// Edit
                Button {
                    withAnimation {
                        showEditView.toggle()
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    print("PRESS - Edit")
                } label: {
                    Image(systemName: "pencil.tip")
                }
                
                /// Bookmark
                Button {
                    withAnimation {
                        note.isfavorite.toggle()
                        WidgetCenter.shared.reloadAllTimelines()
                        animateSymbol.toggle()
                    }
                    print("PRESS - Bookmark")
                } label: {
                    Image(systemName: note.isfavorite ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(note.isfavorite ? .red : .gray)
                        .symbolEffect(.bounce, options: .nonRepeating, value: animateSymbol)
                }
                
                /// Delete
                if note.isCompleted {
                    Button(role: .destructive, action: {
                        withAnimation {
                            context.delete(note)
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        print("PRESS - Delete")
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
            .font(.system(size: 15))
                
            //MARK: - MENU
            /*
            Menu {
                /// Completed
                Button {
                    withAnimation {
                        note.isCompleted.toggle()
                        if note.isCompleted {
                            note.isfavorite = false
                        }
                        note.date = .now
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    print("PRESS - Completed")
                } label: {
                    Text(note.isCompleted ? "Uncompleted" : "Completed")
                    Image(systemName: note.isCompleted ? "checkmark.circle.badge.xmark" : "checkmark.circle")
                }
                
                /// Edit
                Button {
                    withAnimation {
                        showEditView.toggle()
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    print("PRESS - Edit")
                } label: {
                    Text("Edit")
                    Image(systemName: "pencil.tip")
                }
                
                /// Bookmark
                Button {
                    withAnimation {
                        note.isfavorite.toggle()
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    print("PRESS - Bookmark")
                } label: {
                    Text(note.isfavorite ? "Remove bookmark" : "Bookmark")
                    Image(systemName: note.isfavorite ? "bookmark.slash" : "bookmark")
                }
                
                Divider()
                
                /// Delete
                Button(role: .destructive, action: {
                    withAnimation {
                        context.delete(note)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    print("PRESS - Delete")
                }, label: {
                    Text("Delete")
                    Image(systemName: "trash")
                })
                  
            } label: {
                Image(systemName: "ellipsis")
                    .font(.headline.bold())
                    .padding(5)
            }
             */
            
            Text(note.date, formatter: dateFormatter)
        }
        .font(.footnote)
        .foregroundColor(.secondary)
        .padding(.top, 5)
        
        .fullScreenCover(isPresented: $showEditView) {
            EditNoteView(note: note)
        }
    }
}

//#Preview {
//    let preview = Preview(Note.self)
//    return  NavigationStack {
//        ButtonCard(note: Note.sampleNotes[1])
//            .modelContainer(preview.container)
//    }
//}

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
       //     try? Tips.configure([
                // .displayFrequency(.immediate),
         //       .datastoreLocation(.applicationDefault)
       //     ])
        }
}
