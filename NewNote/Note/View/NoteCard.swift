//
//  NoteCardView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import WidgetKit

struct NoteCardView: View {
    @Bindable var note: Note
    /// View Properties
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    
    @State private var detailviewAnimation: Bool = false
    
    @State private var showDetailview: Bool = false
    @State private var isMuted: Bool = true
    
    // Date Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter }()
    
    @State private var offset: CGSize = .zero
    
    init(note: Note) {
        _note = Bindable(note)
        
    }

    var body: some View {
            
        CardView()
            .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
            .animation(.snappy, value: isActive)
            .onAppear {
                isActive = note.title.isEmpty
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                if !isActive && !note.title.isEmpty {
                    /// Complete
                    Button(action: {
                        note.isCompleted.toggle()
                        note.date = .now
                        WidgetCenter.shared.reloadAllTimelines()
                    }, label: {
                        Image(systemName: note.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .padding(3)
                            .contentShape(.rect)
                            .foregroundStyle(note.isCompleted ? .gray : .accentColor)
                            .contentTransition(.symbolEffect(.replace))
                    })
                }
            }
            /// Swipe to delete
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                /// Delete
                Button {
                    context.delete(note)
                    WidgetCenter.shared.reloadAllTimelines()
                } label: {
                    Image(systemName: "trash")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                }
                .tint(.red)
                
                /// Edit
                Button {
             //       context.delete(note)
              //      WidgetCenter.shared.reloadAllTimelines()
                } label: {
                    Image(systemName: "pencil")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                }
                .tint(.blue)
               

                
//                Button("", systemImage: "trash") {
//                    context.delete(note)
//                    WidgetCenter.shared.reloadAllTimelines()
//                }
//                .tint(ColorManager.bgColor)
                
            }
            .onSubmit(of: .text) {
                if note.title.isEmpty {
                    /// Deleting Empty Todo
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
  
    }
    
    //MARK: - CARD View
    @ViewBuilder
    func CardView() -> some View {
        VStack(spacing: 0) {
            if !note.isCompleted {
            VStack {
                // Image
                if let imageData = note.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 170)
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                }
            }
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 3)
            .onTapGesture {
                withAnimation(.snappy(duration: 0.2, extraBounce: 0)) {
                    showDetailview = true
                }
            }
        }
                
                // Text
                OverlayText()
            
            }
            .padding(.horizontal, 3)
            .padding(.top, 3)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(14)
            
    }
    
    // Text
    @ViewBuilder
    private func OverlayText() -> some View {
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
                .foregroundStyle(.secondary)
                .focused($isActive)
                .lineLimit(note.isCompleted ? 1 : nil)
                .padding(.top, 1)
            
            if !note.isCompleted {
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

#Preview {
    let preview = Preview(Note.self)
    return  NavigationStack {
        NoteCardView(note: Note.sampleNotes[1])
            .modelContainer(preview.container)
    }
}
