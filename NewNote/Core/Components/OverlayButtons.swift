//
//  OverlayButtons.swift
//  NewNote
//
//  Created by Benji Loya on 13.02.2024.
//

import SwiftUI

struct OverlayButtons: View {
    @Binding var showPhotoPicker: Bool
    @Binding var showDatePicker: Bool
    @Binding var tag: Tag?
    
    var body: some View {
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
}
