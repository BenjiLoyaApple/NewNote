//
//  NoteRowView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

/*
import SwiftUI
import WidgetKit

struct NoteRowView: View {
    
    @Bindable var note: Note
    /// View Properties
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    
    // Date Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter }()
    
    var body: some View {
        HStack(spacing: 8) {
            if !isActive && !note.title.isEmpty {
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
            
            VStack(alignment: .leading, spacing: 4) {
                
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
                            // Video
                        }
                    }
                    .cornerRadius(12)
                }
                
                Text(note.title)
                    .font(.title3.bold())
                    .strikethrough(note.isCompleted)
                    .foregroundStyle(note.isCompleted ? .gray : .primary)
                    .focused($isActive)
                
                Text(note.subTitle)
                    .font(.subheadline)
                    .strikethrough(note.isCompleted)
                    .foregroundStyle(.secondary)
                    .focused($isActive)
                    .lineLimit(note.isCompleted ? 1 : nil)
                
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
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = note.title.isEmpty
        }
        /// Swipe to delete
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                context.delete(note)
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
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
}

#Preview {
    ContentView()
}
*/
