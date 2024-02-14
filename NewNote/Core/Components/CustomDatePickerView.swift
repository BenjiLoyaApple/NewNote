//
//  CustomDatePickerView.swift
//  NewNote
//
//  Created by Benji Loya on 14.02.2024.
//

import SwiftUI

struct CustomDatePickerView: View {
    @Binding var date: Date
    
    var body: some View {
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
}
