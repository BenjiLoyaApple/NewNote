//
//  PhotoAdd.swift
//  NewNote
//
//  Created by Benji Loya on 13.02.2024.
//

import SwiftUI
import SwiftData
import PhotosUI


//MARK: - Photo
struct NotePhoto: View {
    @Binding var image: Data?
    
    /// Image properties
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            displayImage()
                .shadow(color: .black.opacity(0.25), radius: 10, x: 2, y: 7)
                .overlay(deleteButton(), alignment: .topTrailing)
             //   .matchedGeometryEffect(id: "image", in: namespace)
        }
    }
    
    //MARK: - Display Image
    @ViewBuilder
    private func displayImage() -> some View {
        if let imageData = image,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height * Constants.imageHeightRatio)
                .clipShape(.rect(cornerRadius: Constants.imageCornerRadius))
                .matchedGeometryEffect(id: "image", in: namespace)
        } else {
            Rectangle()
                .fill(Color.clear)
        }
    }
    
    //MARK: - Delete Button
    @ViewBuilder
    private func deleteButton() -> some View {
        if image != nil {
            Button(action: {
                withAnimation {
                    deletePhoto()
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(ColorManager.bgColor)
                    .background(Color.gray)
                    .padding(Constants.deleteButtonPadding)
                    .clipShape(Circle())
                    .padding(6)
            }
        } else {
            EmptyView()
        }
    }
    
    //MARK: - Delete Photo
    private func deletePhoto() {
        if image != nil {
            selectedPhoto = nil
            image = nil
        }
    }
    
    //MARK: - Constants
    private enum Constants {
        static let imageHeightRatio: CGFloat = 0.25
        static let imageCornerRadius: CGFloat = 10
        static let deleteButtonPadding: CGFloat = -2
    }
}

#Preview {
    let preview = Preview(Note.self)
   return  NavigationStack {
       EditNoteView(note: Note.sampleNotes[1])
           .modelContainer(preview.container)
    }
}
