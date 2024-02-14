//
//  CardView.swift
//  NewNote
//
//  Created by Benji Loya on 13.02.2024.
//

import SwiftUI

struct CardView: View {
    @Bindable var note: Note
    
    var body: some View {
        VStack(spacing: 0) {
            // Image
               ImageCard(note: note)
            
            // Text
            TextCard(note: note)
        }
        .padding(.horizontal, 3)
        .padding(.top, 3)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(14)
    }
}
