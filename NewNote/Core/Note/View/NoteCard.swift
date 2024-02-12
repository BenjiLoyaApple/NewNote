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
    
    @State private var showDetailView: Bool = false
    @State private var showEditView: Bool = false
    
    @State private var isTextDetailContent: Bool = false
    @State private var maxTextLines: Int = 5
    
    // Date Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter }()
    
    init(note: Note) {
        _note = Bindable(note)
        
    }
    
    var body: some View {
        SwipeAction(cornerRadius: 15, direction: .trailing) {
            
            CardView()
            
        } actions: {
            /// Complete
            Action(tint: ColorManager.bgColor, icon: note.isCompleted ? "checkmark.circle.fill" : "checkmark.circle.fill", iconTint: note.isCompleted ? .green : .mint) {
                print("Complete note")
                
                withAnimation {
                    note.isCompleted.toggle()
                    note.date = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            /// Edit
            Action(tint: ColorManager.bgColor, icon: "pencil.circle.fill", iconTint: .blue) {
                print("Edit note")
                showEditView.toggle()
                WidgetCenter.shared.reloadAllTimelines()
            }
            /// Delete
            Action(tint: ColorManager.bgColor, icon: "trash.circle.fill", iconTint: .red) {
                print("Delete note")
                withAnimation {
                    context.delete(note)
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
                ///In app Toast
                //                Toast.shared.present(
                //                    title: "Deleted",
                //                    symbol: "xmark.circle",
                //                    tintSymbol: Color.red,
                //                    isUserInteractionEnabled: true,
                //                    timing: .medium
                //                )
            }
        }
        
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = note.title.isEmpty
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
        .fullScreenCover(isPresented: $showEditView) {
            EditNoteView(note: note)
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
                            .frame(height: 190)
                            .cornerRadius(10)
                            .contentShape(Rectangle())
                    }
                }
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 3)
                .onTapGesture {
                    withAnimation(.snappy(duration: 0.2, extraBounce: 0)) {
                        showDetailView = true
                    }
                }
            }
            // Text
            OverlayText()
                .onTapGesture {
                    isTextDetailContent.toggle()
                    withAnimation(.smooth) {
                        maxTextLines = isTextDetailContent ? .max : 5
                    }
                }
            
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
                .foregroundStyle(.primary.opacity(0.8))
                .focused($isActive)
                .padding(.top, 1)
                .lineLimit(
                    note.isCompleted ? 1 : (isTextDetailContent ? nil : maxTextLines)
                )
            
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
