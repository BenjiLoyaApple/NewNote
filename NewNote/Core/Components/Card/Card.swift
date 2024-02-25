//
//  Card.swift
//  NewNote
//
//  Created by Benji Loya on 20.02.2024.
//

import SwiftUI
import WidgetKit

struct Card: View {
    @Bindable var note: Note
    /// View Properties
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    
    @State private var showEditView: Bool = false
    
    init(note: Note) {
        _note = Bindable(note)
    }
    
    var body: some View {
            /// Card View
            VStack(spacing: 0) {
                // Image
                ImageCard(note: note)
                    .padding(.horizontal, 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    // Text
                    TextCard(note: note)
                    
                    Divider()
                        .padding(.top, 10)
                    
                    ButtonCard(note: note)
                       
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 10)
                .padding(.top, 10)
               
            }
            .padding(.top, 3)
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
            }
            .clipShape(.rect(cornerRadius: 14, style: .continuous))
            /// Light White Border
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(ColorManager.cardStroke.opacity(0.3), lineWidth: 1.5)
            }
            /// Adding Shadow
            .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 2)
            .padding(.horizontal, 10)
        
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = note.title.isEmpty
        }
        .onSubmit(of: .text) {
            if note.title.isEmpty {
                /// Deleting Empty Note
                context.delete(note)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && note.title.isEmpty {
                context.delete(note)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            note.isCompleted = note.isCompleted
        }
        .task {
            note.isfavorite = note.isfavorite
        }
        
        .contextMenu{
            /// Share
            Button {
                    // share option
            } label: {
                Text("Share")
                Image(systemName: "square.and.arrow.up")
            }
            
            Divider()
            
            /// Delete
            Button(role: .destructive, action: {
                    context.delete(note)
                    WidgetCenter.shared.reloadAllTimelines()
            }, label: {
                Text("Delete")
                Image(systemName: "trash")
            })
              
        } preview: {
            ImageCard(note: note)
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
