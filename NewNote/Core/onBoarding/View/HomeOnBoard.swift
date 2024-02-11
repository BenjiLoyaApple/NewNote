//
//  HomeOnBoard.swift
//  NewNote
//
//  Created by Benji Loya on 11.02.2024.
//

import SwiftUI

struct HomeOnBoard: View {
    /// view Properties
    @State private var activeIntro: PageIntro = pageIntros[0]
    @AppStorage("userName") var userName: String = ""
    @AppStorage("password") var password: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var start: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            IntroView(intro: $activeIntro, size: size) {
                /// User Login / Signup View
                VStack(spacing: 10) {
                    /// Custom TextField
                    /*
                    CustomTextField(text: $userName, hint: "Username", leadingIcon: Image(systemName: "person"))
                    CustomTextField(text: $password, hint: "Password", leadingIcon: Image(systemName: "lock"), isPassword: true)
                    */
                    Spacer(minLength: 10)
                    
                    //MARK: - Continue
                    Button {
                        logStatus = true
                        start.toggle()
                    } label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: size.width * 0.4)
                                .padding(.vertical, 15)
                                .background {
                                    Capsule()
                                        .fill(.black)
                                }
                        }
                        .frame(maxWidth: .infinity)
                 //   .disabled(userName.isEmpty || password.isEmpty)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.gray.opacity(userName.isEmpty || password.isEmpty ? 0.5 : 1.0))

                    
                    //MARK: - Start without account
                    /*
                    Button {
                        logStatus = true
                        start.toggle()
                    } label: {
                        Text("Start without account")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(.blue.gradient)
                            }
                    }
                    */
                    
                    .fullScreenCover(isPresented: $start, content: {
                        Home()
                    })
                }
                .padding(.top, 25)
            }
        }
        .padding(15)
        /// Manual Keyboard Push
        .offset(y: -keyboardHeight)
        ///  Disabling Native Keyboard Push
        .ignoresSafeArea(.keyboard, edges: .all)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { output in
            if let info = output.userInfo, let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                keyboardHeight = height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: keyboardHeight)
        .preferredColorScheme(.light)
    }
}

struct HomeOnBoard_Previews: PreviewProvider {
    static var previews: some View {
        HomeOnBoard()
    }
}

/// Intro view
struct IntroView<ActionView: View>: View {
    @Binding var intro: PageIntro
    var size: CGSize
    var actionView: ActionView
    
    init(intro: Binding<PageIntro>, size: CGSize, @ViewBuilder actionView: @escaping () -> ActionView) {
        self._intro = intro
        self.size = size
        self.actionView = actionView()
    }
    
    /// ANIMATION PROPERTIES
    @State private var showView: Bool = false
    @State private var hideWholeView: Bool = false
    
    var body: some View{
        VStack {
            /// Image View
            GeometryReader {
                let size = $0.size
                
                Image(intro.introAssetImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
            }
            /// Moving Up
            .offset(y: showView ? 0 : -size.height / 2)
            .opacity(showView ? 1 : 0)
            
            /// Tile & Action's
            VStack(alignment: .leading, spacing: 10) {
                Spacer(minLength: 0)
                
                Text(intro.tittle)
                    .font(.system(size: 40))
                    .fontWeight(.black)
                
                Text(intro.subTittle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 15)
                
                if !intro.displayysAction {
                    Group {
                        Spacer(minLength: 25)
                        
                        /// Custom indicator View
                        CustomIndicatorView(totalPages: filteredPages.count, currentPage: filteredPages.firstIndex(of: intro) ?? 0)
                            .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            changeIntro()
                        } label: {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: size.width * 0.4)
                                .padding(.vertical, 15)
                                .background {
                                    Capsule()
                                        .fill(.black)
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    ///  Action View
                    actionView
                        .offset(y: showView ? 0 : size.height / 2)
                        .opacity(showView ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            /// Moving Down
            .offset(y: showView ? 0 : size.height / 2)
            .opacity(showView ? 1 : 0)
        }
        .offset(y: hideWholeView ? size.height / 2 : 0)
        .opacity(hideWholeView ? 0 : 1)
        
        ///  Back button
        .overlay(alignment: .topLeading) {
            /// Hiding it for Very First Page
            
            if intro != pageIntros.first {
                Button {
                    changeIntro(true)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
                .padding(10)
                /// Animating Back Button
                ///  Comes from Top
                .offset(y: showView ? 0 : -200)
                ///  Hides by Going back to Top When in Active
                .offset(y: hideWholeView ? -200 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0).delay(0.1)) {
                showView = true
            }
        }
    }
    
    /// Updating page Intro
    func changeIntro(_ isPrevious: Bool = false) {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
            hideWholeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          /// Updating Page
            if let index = pageIntros.firstIndex(of: intro), (isPrevious ? index != 0 : index != pageIntros.count - 1) {
                intro = isPrevious ? pageIntros[index - 1] : pageIntros[index + 1]
            } else {
                intro = isPrevious ? pageIntros[0] : pageIntros[pageIntros.count - 1]
        }
            /// Re-Animating as Split Page
            hideWholeView = false
            showView = false
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
                showView = true
            }
        }
    }
    
        var filteredPages: [PageIntro] {
            return pageIntros.filter{ !$0.displayysAction }
        
    }
}
