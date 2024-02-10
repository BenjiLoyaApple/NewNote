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
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    DescriptionAdd()
                        .padding(.horizontal)
                }
                .padding([.horizontal, .top])
                
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
        }
    }
    
    //MARK: - Add Note
    /// Adding Notes to the Swift Data
    func addNotes() {
        let note = Note(
            title: title,
            subTitle: subTitle,
            tag: .clear
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
