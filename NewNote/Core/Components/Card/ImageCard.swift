//
//  ImageCard.swift
//  NewNote
//
//  Created by Benji Loya on 13.02.2024.
//

import SwiftUI

//MARK: - Image
struct ImageCard: View {
    @Bindable var note: Note
    
    @State private var showDetailView: Bool = false
    
    var body: some View {
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
                    print("Show Edit View")
                }
            }
        } 
        
        
    }
}

#Preview {
    let preview = Preview(Note.self)
    return  NavigationStack {
        ImageCard(note: Note.sampleNotes[1])
            .modelContainer(preview.container)
    }
}
