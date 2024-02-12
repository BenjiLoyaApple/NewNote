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
                PhotoDetail()
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                
                TitleDetail()
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
                OverlayButtons()
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //MARK: Toast notification
//                        Toast.shared.present(
//                            title: "Changes saved",
//                            symbol: "checkmark.circle",
//                            tintSymbol: Color.green,
//                            isUserInteractionEnabled: true,
//                            timing: .medium
//                        )
                    }
                    
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
            VStack {
                HStack {
                    Image(systemName: "calendar")
                    Text("Set Custom Date")
                    Spacer()
                }
                .font(.headline)
                .padding(.leading, 30)
                
                DatePicker("Select a date", selection: $date, displayedComponents: [.date])
                    .padding(.horizontal)
                    .datePickerStyle(.graphical)
                    .presentationDetents([.medium])
                    .presentationCornerRadius(25)
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .any(of: [.images]))
        .onChange(of: selectedPhoto) { newValue in
            Task {
                do {
                    /// preobrazyem foto v daniie
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

    //MARK: - Delete Photo
    func deletePhoto() {
            if image != nil {
                selectedPhoto = nil
                image = nil
            }
    }
    
    // Photo
    @ViewBuilder
    private func PhotoDetail()->some View {
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
                        deletePhoto()
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
    
    //MARK: Description
    @ViewBuilder
    private func TitleDetail() -> some View {
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
            
            HStack(spacing: 4) {
                if isDateVisible {
                    Text(date, formatter: dateFormatter)
                        .transition(.opacity)
                }
                
                Spacer()
                
                if let tag = tag {
                    Circle()
                        .frame(height: 10)
                        .foregroundColor(tag.color)
                        .padding(4)
                    
                    Text(tag.name)
                }
            }
            .font(.footnote)
            .foregroundColor(.primary.opacity(0.4))
            .padding(.top, 10)
            .onChange(of: date) { newDate in
                withAnimation {
                    isDateVisible = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        isDateVisible = false
                    }
                }
            }
            
        }
    }
    
    //MARK: Overlay Buttons
    @ViewBuilder
    private func OverlayButtons() -> some View {
        Menu {
            //Photo
            Button(action: {
                withAnimation(.bouncy) {
                    showPhotoPicker.toggle()
                }
            }, label: {
                Text("Select Photo")
                Image(systemName: "photo.on.rectangle.angled")
            })
            
            //Calendar
            Button(action: {
                withAnimation(.bouncy) {
                    showDatePicker.toggle()
                }
            }, label: {
                Text("Date")
                Image(systemName: "calendar")
            })
            
            /// Tag
            Menu {
                ForEach(Tag.allCases, id: \.self) { tag in
                    Button {
                        self.tag = tag
                    } label: {
                        Button {
                            self.tag = tag
                        } label: {
                            Text(tag.name)
                        }
                    }
                }
                
            } label: {
                if let selectedTag = tag {
                    Text(selectedTag.name)
                        Image(systemName: "circle")
                } else {
                    Text("Tag")
                    Image(systemName: "square.stack")
                }
            }
            
        }label: {
            Image(systemName: "plus.circle")
                .foregroundStyle(ColorManager.textColor)
        }
    }
}

#Preview {
    let preview = Preview(Note.self)
   return  NavigationStack {
       EditNoteView(note: Note.sampleNotes[1])
           .modelContainer(preview.container)
    }
}
