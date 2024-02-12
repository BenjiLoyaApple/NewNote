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
    @State private var tag: Tag?
    @State private var date: Date = .init()
    
    /// Image properties
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
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
                    
                    DescriptionAdd()
                        .padding(.horizontal)
                }
                .padding(.bottom, 330)
                
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
    
    //MARK: - Photo
    @ViewBuilder
    private func PhotoDetail() -> some View {
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
        .shadow(color: .black.opacity(0.25), radius: 10, x: 2, y: 7)
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

    //MARK: - Overlay Buttons
    @ViewBuilder
    private func OverlayButtons() -> some View {
        Menu {
            ///Photo
            Button(action: {
                withAnimation(.bouncy) {
                    showPhotoPicker.toggle()
                }
            }, label: {
                Text("Select Photo")
                Image(systemName: "photo.on.rectangle.angled")
            })
            .sensoryFeedback(.selection, trigger: showPhotoPicker)
            
            ///Calendar
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
    
    //MARK: - Delete Photo
    func deletePhoto() {
            if image != nil {
                selectedPhoto = nil
                image = nil
            }
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
