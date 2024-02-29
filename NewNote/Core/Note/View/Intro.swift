//
//  IntroView.swift
//  NewNote
//
//  Created by Benji Loya on 27.02.2024.
//

import SwiftUI

struct Intro: View {
    @State private var moveUp = false
    @State private var moveDown = false
    
    @State private var textOpen = false
    
    @State private var showHome = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BookmarkShape()
                    .rotationEffect(.degrees(180), anchor: .center)
                    .frame(width: 250, height: 550)
                    .offset(y: moveDown ? 0 : -500)
                    .offset(y: moveUp ? -700 : -250)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .bottom, endPoint: .top))
                
                Text("Just Journal")
                    .font(.system(size: 40))
                    .fontWeight(.black)
                    .opacity(textOpen ? 1 : 0)
                    .scaleEffect(textOpen ? 1 : 0.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 8.8)) {
                        self.moveDown = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.moveUp = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    withAnimation(.interpolatingSpring(stiffness: 80, damping: 10)) {
                        self.textOpen = true
                    }
                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    showHome = true
//                }
            }
//            .fullScreenCover(isPresented: $showHome) {
//                Home()
//            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Intro()
    }
}


struct BookmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        
        let path = Path { path in
            path.move(to: CGPoint(x: width * 0.5, y: height * 0.32))
            path.addLine(to: CGPoint(x: width, y: height * 0.2))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: height * 0.2))
       
        }
        
        return path
    }
}
