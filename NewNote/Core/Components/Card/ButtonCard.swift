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
                CustomButton(action: {
                    withAnimation {
                            note.isCompleted.toggle()
                            note.isfavorite = false
                        if note.isCompleted == false {
//                            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
//                            note.date = tomorrow
                            note.date = .now
                        }

                        WidgetCenter.shared.reloadAllTimelines()
                        
                        /// Delete + 1 day
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 24 * 60 * 60) {
//                                context.delete(note)
//                        }
                    }
                    HapticManager.instance.impact(style: .light)
                    
                }, label: {
                    Image(systemName: note.isCompleted ? "checkmark.circle.badge.xmark" : "checkmark.circle")
                        .foregroundStyle(note.isCompleted ? .green : .primary.opacity(0.6))
                })
                
                /// Edit
                if !note.isCompleted { /// Don't show in Complete list
                    CustomButton(action: {
                        withAnimation {
                            showEditView.toggle()
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        HapticManager.instance.impact(style: .light)
                    }, label: {
                        Image(systemName: "pencil.tip")
                    })
                    
                    /// Bookmark
                    CustomButton(action: {
                        withAnimation {
                            note.isfavorite.toggle()
                            WidgetCenter.shared.reloadAllTimelines()
                            animateSymbol.toggle()
                        }
                        HapticManager.instance.impact(style: .soft)
                    }, label: {
                        Image(systemName: note.isfavorite ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(note.isfavorite ? ColorManager.cardBookmark : .primary.opacity(0.6))
                            .symbolEffect(.bounce, options: .nonRepeating, value: animateSymbol)
                    })
                }
                
                /// Delete
                if note.isCompleted { /// Show only to complete List
                    CustomButton(action: {
                        withAnimation {
                            context.delete(note)
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        HapticManager.instance.notification(type: .error)
                    }, label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
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

#Preview {
    let preview = Preview(Note.self)
    return  NavigationStack {
        Card(note: Note.sampleNotes[1])
            .modelContainer(preview.container)
    }
}
