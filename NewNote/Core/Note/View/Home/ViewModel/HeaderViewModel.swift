//
//  HeaderViewModel.swift
//  NewNote
//
//  Created by Benji Loya on 08.03.2024.
//

import SwiftUI

actor TitleDatabase {
    
    func getNewTitle() -> String {
        "Just Jourlal"
    }
}

//MARK: - ViewModel
@Observable class HeaderViewModel {
    
    @ObservationIgnored let data = TitleDatabase()
    @MainActor var title: String = ""
    
    init() {
        startTitle()
    }
    
    func startTitle() {
        Task { @MainActor in
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 6..<12:
                title = "Good morning"
                case 12..<18:
                    title = "Good afternoon"
                case 18..<22:
                    title = "Good evening"
                default:
                    title = "Good night"
            }
            print(Thread.current)
        }
    }
    
    func updateTitle() {
        Task { @MainActor in
            title = await data.getNewTitle()
            print(Thread.current)
        }
    }
}


//MARK: - View
struct HeaderView: View {
    @State private var viewModel = HeaderViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .shadow(color: ColorManager.textColor.opacity(0.2), radius: 1, x: 2, y: 2)
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            viewModel.updateTitle()
                        }
                    }
                Spacer()
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    HeaderView()
        .padding(.leading)
}
