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
    @Environment(\.scenePhase) private var phase
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
            HStack(spacing: 8) {
                if let tag = note.tag {
                    Image(systemName: "circle.fill")
                        .frame(height: 10)
                        .padding(3)
                        .containerShape(.rect)
                        .foregroundStyle(tag.color.gradient)
                    
                }
                Text(note.date, formatter: dateFormatter)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            
            Spacer()
            
            //MARK: - Buttons
            HStack(spacing: 5) {
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
                    HapticManager.instance.impact(style: .light)
                    print("PRESS - Completed")
                } label: {
                    Image(systemName: note.isCompleted ? "checkmark.circle.badge.xmark" : "checkmark.circle")
                        .foregroundStyle(note.isCompleted ? .green : .primary.opacity(0.6))
                        .padding(10)
                        .background {
                            TransparentBlurView(removeAllFilters: false)
                                .background(.clear.opacity(0.1))
                        }
                        .clipShape(Circle())
                }
                
                /// Edit
                Button {
                    withAnimation {
                        showEditView.toggle()
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    HapticManager.instance.impact(style: .light)
                    print("PRESS - Edit")
                } label: {
                    Image(systemName: "pencil.tip")
                        .padding(10)
                        .background {
                            TransparentBlurView(removeAllFilters: false)
                                .background(.clear.opacity(0.1))
                        }
                        .clipShape(Circle())
                }
                
                /// Bookmark
                Button {
                    withAnimation {
                        note.isfavorite.toggle()
                        WidgetCenter.shared.reloadAllTimelines()
                        animateSymbol.toggle()
                    }
                    HapticManager.instance.impact(style: .soft)
                    print("PRESS - Bookmark")
                } label: {
                    Image(systemName: note.isfavorite ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(note.isfavorite ? .red : .primary.opacity(0.6))
                        .symbolEffect(.bounce, options: .nonRepeating, value: animateSymbol)
                        .padding(10)
                        .background {
                            TransparentBlurView(removeAllFilters: false)
                                .background(.clear.opacity(0.1))
                        }
                        .clipShape(Circle())
                }
                
                /// Delete
                if note.isCompleted {
                    Button(role: .destructive, action: {
                        withAnimation {
                            context.delete(note)
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        HapticManager.instance.notification(type: .error)
                        print("PRESS - Delete")
                    }, label: {
                        Image(systemName: "trash")
                            .padding(10)
                            .background {
                                TransparentBlurView(removeAllFilters: false)
                                    .background(.clear.opacity(0.1))
                            }
                            .clipShape(Circle())
                    })
                }
            }
            .foregroundStyle(.primary.opacity(0.6))
           
        }
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

#Preview {
    let preview = Preview(Note.self)
    return  NavigationStack {
        Card(note: Note.sampleNotes[1])
            .modelContainer(preview.container)
    }
}

//#Preview("English") {
//    let preview = Preview(Note.self)
//    let notes = Note.sampleNotes
//    preview.addExamples(notes)
//    return ContentView()
//        .modelContainer(preview.container)
//        .environment(\.locale, Locale(identifier: "EN"))
//}





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
 .padding(10)
 .background {
     TransparentBlurView(removeAllFilters: false)
         .background(.clear.opacity(0.1))
 }
 .clipShape(Circle())
}
 */
