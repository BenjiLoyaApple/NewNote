//
//  AddNoteView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData
import PhotosUI
import WidgetKit

struct AddNotesView: View {
    /// View Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var image: Data?
    @State private var tag: Tag?
    @State private var date: Date = .init()
    
    /// Image properties
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    @State private var showDatePicker = false
    
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    NotePhoto(image: $image, namespace: namespace)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                    
                    NoteText(title: $title, subTitle: $subTitle)
                        .padding(.horizontal)
                }
                .padding(.bottom, 330)
                
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    // Cancel
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    OverlayButtons(showPhotoPicker: $showPhotoPicker, showDatePicker: $showDatePicker, tag: $tag)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    // Add
                    Button(action: {
                        withAnimation(.bouncy) {
                            addNotes()
                        }
                    }, label: {
                        Text("Add")
                            .foregroundStyle(ColorManager.textColor)
                    })
                    .disableWithOpacity(isAddButtonDisabled)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .ignoresSafeArea(.keyboard)
           
            .sheet(isPresented: $showDatePicker) {
                CustomDatePickerView(date: $date)
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .any(of: [.images]))
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    do {
                        /// преобразуем фото в данные
                        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                            DispatchQueue.main.async {
                                image = data
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    /// Disabled Add Button, until all data has been enterd
    var isAddButtonDisabled: Bool {
        return title.isEmpty || subTitle.isEmpty
    }
    
    
    //MARK: - Add Note
    /// Adding Notes to the Swift Data
    func addNotes() {
        let note = Note(
            title: title,
            subTitle: subTitle,
            date: date,
            image: image ?? nil,
            tag: tag ?? nil
        )
        context.insert(note)
        WidgetCenter.shared.reloadAllTimelines()
        /// Closing view, once the Data has been Added Successfully!
        dismiss()
        
    }
}

#Preview {
    AddNotesView()
}

