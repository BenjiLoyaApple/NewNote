//
//  AddNoteView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddNotesView: View {
    /// View Properties
    @FocusState private var isActive: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var image: Data?
    
    /// Image properties
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    PhotoDetail()
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                    
                    DescriptionAdd()
                        .padding(.horizontal)
                }
                .padding(.bottom, 330)
             //   .padding([.horizontal, .top])
                
            }
            .navigationTitle("Add Entry")
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
                    OverlayButtons()
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
           
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .any(of: [.images]))
            .onChange(of: selectedPhoto) { newValue in
//                Task {
//                    isVideoProcessing = true
//                    do {
//                        if let pickedMovie = try? await newValue?.loadTransferable(type: VideoPickerTransferable.self) {
//                            DispatchQueue.main.async {
//                                videoURL = pickedMovie.videoURL
//                                image = nil // Очищаем изображение при выборе видео
//                            }
//                        }
//                    }
//                    isVideoProcessing = false
//                }
                Task {
                    do {
                        /// preobrazyem foto v daniie
                        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                            DispatchQueue.main.async {
                                image = data
                        //        videoURL = nil // Очищаем видео при выборе изображения
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
    
    //MARK: - Description
    @ViewBuilder
    private func DescriptionAdd() -> some View {
        // Description
        VStack(alignment: .leading, spacing: 15) {
            TextField("Title", text: $title)
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(.primary)
                .shadow(color: ColorManager.myBg, radius: 2)
                .onChange(of: title) {
                    if title.count > 20 {
                        title = String(title.prefix(20))
                    }
                }
            
            TextField("Description", text: $subTitle, axis: .vertical)
        }
    }
    
    //MARK: - Photo & video
    // Photo
    @ViewBuilder
    private func PhotoDetail()->some View {
        // Photo
        VStack {
            if let imageData = image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
        .shadow(color: .black.opacity(0.4), radius: 10, x: 2, y: 7)
        .overlay(alignment: .topTrailing) {
            if image != nil {
                Button(role: .destructive) {
                    withAnimation {
                        deleteVideo()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(ColorManager.cardBg)
                        .background(Color.gray)
                        .padding(-2)
                        .clipShape(Circle())
                        .padding(6)
                }
            }
        }
    }

    //MARK: - Overlay Buttons
    @ViewBuilder
    private func OverlayButtons() -> some View {
        Menu {
            //Photo
            Button(action: {
                withAnimation(.bouncy) {
                    showPhotoPicker.toggle()
                }
            }, label: {
                Text("Photo and Video")
                Image(systemName: "photo.on.rectangle.angled")
            })
            .sensoryFeedback(.selection, trigger: showPhotoPicker)
            
            //Calendar
//            Button(action: {
//                withAnimation(.bouncy) {
//                    showDatePicker.toggle()
//                }
//            }, label: {
//                Text("Date")
//                Image(systemName: "calendar")
//            })
//            .sensoryFeedback(.selection, trigger: showDatePicker)
            
            /// Tag
//            Menu {
//                ForEach(Tag.allCases, id: \.self) { tag in
//                    Button {
//                        self.tag = tag
//                    } label: {
//                        Button {
//                            self.tag = tag
//                        } label: {
//                            Text(tag.name)
//                        }
//                    }
//                }
//                
//            } label: {
//                if let selectedTag = tag {
//                    Text(selectedTag.name)
//                        Image(systemName: "circle")
//                } else {
//                    Text("Tag")
//                    Image(systemName: "square.stack")
//                }
//            }
  
        }label: {
            Image(systemName: "plus.circle")
                .foregroundStyle(ColorManager.textColor)
        }
    }
    
    /// Delete
    func deleteVideo() {
        do {
//            if let selectedVideoURL = videoURL {
//                try FileManager.default.removeItem(at: selectedVideoURL)
//                self.videoURL = nil
//                selectedPhoto = nil
//            }

            // Добавляем удаление выбранного изображения
            if image != nil {
                selectedPhoto = nil
                image = nil
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Add Note
    /// Adding Notes to the Swift Data
    func addNotes() {
        let note = Note(
            title: title,
            subTitle: subTitle,
            image: image ?? nil,
            tag: .clear
        )
        context.insert(note)
        
        /// Closing view, once the Data has been Added Successfully!
        dismiss()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            //MARK: Toast notification
//            Toast.shared.present(
//                title: "Entry Added",
//                symbol: "tray.full",
//                tintSymbol: Color.teal,
//                isUserInteractionEnabled: true,
//                timing: .medium
//            )
//        }
    }
}

#Preview {
    AddNotesView()
}
