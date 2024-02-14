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
    @Binding var tag: Tag?
    @Binding var date: Date
    
    @Binding  var isDateVisible: Bool
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            titleTextField
            subTitleTextField
            tagAndDateView
        }
    }
    
    private var titleTextField: some View {
        TextField("Title", text: $title)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.primary)
            .shadow(color: ColorManager.myBg, radius: 2)
            .onChange(of: title) { newTitle in
                enforceTitleMaxLength()
            }
    }
    
    private var subTitleTextField: some View {
        TextField("Description", text: $subTitle, axis: .vertical)
    }
    
    private var tagAndDateView: some View {
        HStack(spacing: 4) {
            if isDateVisible {
                Text(date, formatter: dateFormatter)
                    .transition(.opacity)
            }
            Spacer()
            
            tagView
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
    
    private var tagView: some View {
        Group {
            if let tag = tag {
                Circle()
                    .frame(height: 10)
                    .foregroundColor(tag.color)
                    .padding(4)
                
                Text(tag.name)
            }
        }
    }
    
    private func enforceTitleMaxLength() {
        if title.count > 20 {
            title = String(title.prefix(20))
        }
    }
    
}


/*
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
*/
