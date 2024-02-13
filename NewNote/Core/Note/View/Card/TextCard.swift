//
//  TextCard.swift
//  NewNote
//
//  Created by Benji Loya on 13.02.2024.
//

import SwiftUI

//MARK: - Text
struct TextCard: View {
    @Bindable var note: Note
    /// View Properties
    @FocusState private var isActive: Bool
    @State private var isTextDetailContent: Bool = false
    @State private var maxTextLines: Int = 5
    
    // Date Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .fontWeight(.bold)
                .strikethrough(note.isCompleted)
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
            
            if !note.isCompleted {
                
                Divider()
                    .padding(.top)
                
                HStack(spacing: 4) {
                    if let tag = note.tag {
                        Menu {
                            ForEach(Tag.allCases, id: \.rawValue) { tag in
                                Button(action: { note.tag = tag }, label: {
                                    HStack {
                                        Text(tag.rawValue)
                                        
                                        if note.tag == tag { Image(systemName: "checkmark") }
                                    }
                                })
                            }
                        } label: {
                            HStack(spacing: 5) {
                                if let tag = note.tag {
                                    Image(systemName: "circle.fill")
                                        .frame(height: 10)
                                        .padding(3)
                                        .containerShape(.rect)
                                        .foregroundStyle(tag.color.gradient)
                                }
                                
                                Text(tag.name)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text(note.date, formatter: dateFormatter)
                }
                .font(.footnote)
                .foregroundColor(.primary.opacity(0.4))
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .padding(10)
        
    }
}
