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
    
    var body: some View {
        VStack {
            displayImage()
                .shadow(color: .black.opacity(0.25), radius: 10, x: 2, y: 7)
                .overlay(deleteButton(), alignment: .topTrailing)
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
                    .foregroundStyle(ColorManager.cardBg)
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
    AddNotesView()
}




/*
//MARK: - Photo
struct NotePhoto: View {
    @Binding var image: Data?
    
    /// Image properties
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker: Bool = false
    
    var body: some View {
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
    //MARK: - Delete Photo
    func deletePhoto() {
            if image != nil {
                selectedPhoto = nil
                image = nil
            }
    }
}
*/
