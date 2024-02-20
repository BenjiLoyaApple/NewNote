//
//  EditNoteView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import PhotosUI

struct EditNoteView: View {
    @Environment(\.dismiss) private var dismiss
    let note: Note
    
    @State private var title = ""
    @State private var subTitle = ""
    @State private var date: Date = .init()
    @State private var image: Data? = nil
    @State private var tag: Tag?
    
    /// Photo
    @State private var selectedPhoto: PhotosPickerItem?
    ///showing Pickers
    @State private var showPhotoPicker = false
    @State private var showDatePicker = false
    @State private var isDateVisible = false
    
    // Date Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter }()
    
    
    var body: some View {
        NavigationStack {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                NotePhoto(image: $image)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                
                NoteText(title: $title, subTitle: $subTitle)
                    .padding(.horizontal)
            }
            .padding(.bottom, 330)
            
        }
        .navigationTitle("Edit Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Close Button
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NewNote.OverlayButtons(showPhotoPicker: $showPhotoPicker, showDatePicker: $showDatePicker, tag: $tag)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if changed {
                        note.title = title
                        note.subTitle = subTitle
                        note.date = date
                        note.image = image
                        note.tag = tag
                    }
                    dismiss()
                   
                    
                }, label: {
                    Text("Done")
                        .foregroundStyle(ColorManager.textColor)
                })
                .disableWithOpacity(!changed)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
        .scrollDismissesKeyboard(.interactively)
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
        .onAppear {
            title = note.title
            subTitle = note.subTitle
            date = note.date
            image = note.image
            tag = note.tag
        }
    }
}
    
    var changed: Bool {
        title != note.title
        || subTitle != note.subTitle
        || date != note.date
        || image != note.image
        || tag != note.tag
    }

}

#Preview {
    let preview = Preview(Note.self)
   return  NavigationStack {
       EditNoteView(note: Note.sampleNotes[4])
           .modelContainer(preview.container)
    }
}
