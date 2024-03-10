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
        greetingTitle()
    }
    
    func greetingTitle() {
        Task { @MainActor in
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 6..<12:
                title = "Good morning"
                case 12..<18:
                    title = "Hello"
                case 18..<24:
                    title = "Good evening"
                default:
                    title = "Welcome back"
            }
        }
    }
    
    func updateTitle() {
           Task { @MainActor in
                   title = await data.getNewTitle()
           }
       }
    
}


//MARK: - View
struct HeaderView: View {
    @State private var viewModel = HeaderViewModel()
    @State private var showAll: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .shadow(color: ColorManager.textColor.opacity(0.2), radius: 1, x: 2, y: 2)
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            withAnimation() {
                                viewModel.updateTitle()
                            }
                        }
                    }
                
                Spacer()
                
            }
            .cornerRadius(10)
        }
        .padding(.top, 10)
    }
}

#Preview {
    HeaderView()
        .padding(.horizontal)
}
