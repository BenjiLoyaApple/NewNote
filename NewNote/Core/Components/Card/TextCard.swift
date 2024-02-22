//
//  TextCard.swift
//  NewNote
//
//  Created by Benji Loya on 13.02.2024.
//

import SwiftUI
import WidgetKit

//MARK: - Text
struct TextCard: View {
    @Bindable var note: Note
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    /// View Properties
    @FocusState private var isActive: Bool
    @State private var isTextDetailContent: Bool = false
    @State private var maxTextLines: Int = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(note.isCompleted ? .gray : .primary)
                .focused($isActive)
                .lineLimit(1)
            
            Text(note.subTitle)
                .font(.callout)
                .strikethrough(note.isCompleted)
                .foregroundStyle(note.isCompleted ? .gray : .primary.opacity(0.8))
                .focused($isActive)
                .padding(.top, 1)
                .lineLimit(
                    note.isCompleted ? 1 : (isTextDetailContent ? nil : maxTextLines)
                )
                .onTapGesture {
                    isTextDetailContent.toggle()
                    withAnimation(.smooth) {
                        maxTextLines = isTextDetailContent ? .max : 5
                    }
                }
            
        }
    }
}

#Preview {
    let preview = Preview(Note.self)
    return  NavigationStack {
        TextCard(note: Note.sampleNotes[1])
            .modelContainer(preview.container)
    }
}

