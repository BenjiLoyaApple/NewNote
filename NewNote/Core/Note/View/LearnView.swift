//
//  LearnView.swift
//  NewNote
//
//  Created by Benji Loya on 27.02.2024.
//

import SwiftUI

struct LearnView: View {
    /// Circle
    @State private var moveDown = false
    @State private var moveLeft = false
    @State private var moveRight = false
    @State private var circleOpacity = false
   ///  Text
    @State private var textOpacity = false
        
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                CircleView(moveDown: $moveDown, moveLeft: $moveLeft, moveRight: $moveRight, circleOpacity: $circleOpacity)
                               
                ActionTextView(textOpacity: $textOpacity)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 8)
                
                VStack(spacing: 4) {
                    Text("Swipe Down")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Hold and move left or right")
                    
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.3)
                
            }
            
        }
        .ignoresSafeArea()
        .background(Color.black.opacity(0.85))
        .background {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 4)
            
        }
        .onAppear {
            animateElements()
        }
        
    }
    
    private func animate<Element: Equatable>(property: Binding<Element>, toValue value: Element, afterDelay delay: TimeInterval, animation: Animation) {
        guard property.wrappedValue != value else { return } // Проверяем, не установлено ли уже нужное значение
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(animation) {
                property.wrappedValue = value
            }
        }
    }

    private func animateElements() {
        animate(property: $moveDown, toValue: true, afterDelay: 1.1, animation: .spring(response: 0.8, dampingFraction: 0.8, blendDuration: 8.8))
        animate(property: $moveLeft, toValue: true, afterDelay: 2.5, animation: .easeInOut(duration: 0.8))
        animate(property: $moveRight, toValue: true, afterDelay: 3.7, animation: .easeInOut(duration: 0.8))
        animate(property: $circleOpacity, toValue: true, afterDelay: 4.5, animation: .easeInOut(duration: 0.8))
        
        // Text
        animate(property: $textOpacity, toValue: true, afterDelay: 1.3, animation: .easeInOut(duration: 0.5))
        animate(property: $textOpacity, toValue: false, afterDelay: 4.8, animation: .easeInOut(duration: 0.5))
    }

}

#Preview {
    LearnView()
//    Home()
}


// Circle
struct CircleView: View {
    @Binding var moveDown: Bool
    @Binding var moveLeft: Bool
    @Binding var moveRight: Bool
    @Binding var circleOpacity: Bool
    
    var body: some View {
        Image(systemName: "circle")
            .resizable()
            .frame(width: 50, height: 50)
            .offset(y: moveDown ? 0 : -250)
            .offset(x: moveLeft ? -120 : 0)
            .offset(x: moveRight ? 240 : 0)
            .opacity(circleOpacity ? 0 : 1)
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .bottom, endPoint: .top))
    }
}

// Actions
struct ActionTextView: View {
    @Binding var textOpacity: Bool
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                Text("Search")
                    .font(.caption2)
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                Image(systemName: "arrow.counterclockwise")
                Text("Refresh")
                    .font(.caption2)
            }
            
            Spacer()
                
            VStack(spacing: 10) {
                Image(systemName: "bookmark")
                Text("Bookmark")
                    .font(.caption2)
            }
        }
        .font(.title2)
        .opacity(textOpacity ? 1 : 0)
        .padding(.horizontal, 50)
        .foregroundColor(.white)
    }
}
