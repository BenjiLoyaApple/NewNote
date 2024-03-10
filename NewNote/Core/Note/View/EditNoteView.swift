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
    
    // View Properties
    @State private var detailviewAnimation: Bool = false
    @State private var showDetailview: Bool = false
    @State private var offset: CGSize = .zero
    
    @Namespace private var namespace
    
    
    var body: some View {
        NavigationStack {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                NotePhoto(image: $image, namespace: namespace)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.6, extraBounce: 0)) {
                            showDetailview = true
                        }
                    }
                
                NoteText(title: $title, subTitle: $subTitle)
                    .padding(.horizontal)
            }
            .padding(.bottom, 330)
            
        }
        .navigationTitle("Edit")
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
        .overlay {
            if showDetailview {
                GeometryReader { proxy in
                    let size = proxy.size
                    let safeArea = proxy.safeAreaInsets
                    DetailView(image: $image, showDetailview: $showDetailview,
                               detailviewAnimation: $detailviewAnimation,
                               size: size,
                               safeArea: safeArea,
                               namespace: namespace)
                    .transition(.scale)
                    .cornerRadius(40)
                    .shadow(radius: 40)
                    .offset(offset)
                    .opacity(1 - Double(abs(offset.height) / (proxy.size.height / 0.25)))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.bouncy) {
                                    offset = value.translation
                                }
                            }
                            .onEnded { value in
                                withAnimation(.bouncy) {
                                    let screenHeight = proxy.size.height
                                    let closeThreshold = screenHeight / 2
                                    
                                    if value.translation.height > closeThreshold {
                                        showDetailview = false
                                        offset = .zero
                                    } else {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                }
                .ignoresSafeArea()
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
       EditNoteView(note: Note.sampleNotes[1])
           .modelContainer(preview.container)
    }
}
