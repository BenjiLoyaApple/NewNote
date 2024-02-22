//
//  CustomButtonCard.swift
//  NewNote
//
//  Created by Benji Loya on 23.02.2024.
//

import SwiftUI

struct CustomButton<Content: View>: View {
    let action: () -> Void
    let label: () -> Content
    
    var body: some View {
        Button(action: action) {
            label()
                .padding(10)
                .background {
                    TransparentBlurView(removeAllFilters: false)
                        .background(.clear.opacity(0.1))
                }
                .clipShape(Circle())
        }
    }
}
