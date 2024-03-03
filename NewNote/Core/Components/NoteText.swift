//
//  TextAdd.swift
//  NewNote
//
//  Created by Benji Loya on 13.02.2024.
//

import SwiftUI
import SwiftData

//MARK: - Text
struct NoteText: View {
    @Binding var title: String
    @Binding var subTitle: String
  
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleTextField
            subTitleTextField
        }
    }
    
    //MARK: - Title
    private var titleTextField: some View {
        TextField("Title", text: $title)
            .font(.title2)
            .fontWeight(.black)
            .foregroundColor(.primary)
            .onChange(of: title) { oldTitle, newTitle in
                enforceTitleMaxLength()
            }
    }
    
    //MARK: - Description
    private var subTitleTextField: some View {
        TextField("Description", text: $subTitle, axis: .vertical)
    }
    
    
    private func enforceTitleMaxLength() {
        if title.count > 22 {
            title = String(title.prefix(22))
        }
    }
    
}


#Preview {
    let preview = Preview(Note.self)
   return  NavigationStack {
       EditNoteView(note: Note.sampleNotes[5])
           .modelContainer(preview.container)
    }
}
