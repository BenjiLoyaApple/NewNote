//
//  HomeBG.swift
//  NewNote
//
//  Created by Benji Loya on 23.02.2024.
//

import SwiftUI

struct HomeBG: View {
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    .linearGradient(colors: [
                        .indigo.opacity(0.1),
                        .purple.opacity(0.15)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 150)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 25, y: -505)
            
            Circle()
                .fill(
                    .linearGradient(colors: [
                        .blue.opacity(0.1),
                        .mint.opacity(0.15)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 280)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: -85, y: 220)
            
            Circle()
                .fill(
                    .linearGradient(colors: [
                        .orange.opacity(0.1),
                        .pink.opacity(0.15)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 340)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 125, y: 25)
             
        }
    }
}


#Preview {
    HomeBG()
}


/*
 Image("iOS-17-Dark")
     .resizable()
     .aspectRatio(contentMode: .fill)
     .opacity(0.1)
     .ignoresSafeArea()
 
 */


/*
 import SwiftUI

 struct HomeBG: View {
     
     @State private var circle1Width: CGFloat = 150
     @State private var circle1OffsetX: CGFloat = 25
     @State private var circle1OffsetY: CGFloat = -505
     @State private var circle1GradientColors: [Color] = [.indigo.opacity(0.1), .purple.opacity(0.15)]
     
     @State private var circle2Width: CGFloat = 150
     @State private var circle2OffsetX: CGFloat = -85
     @State private var circle2OffsetY: CGFloat = 220
     @State private var circle2GradientColors: [Color] = [.blue.opacity(0.1), .mint.opacity(0.15)]
     
     @State private var circle3Width: CGFloat = 150
     @State private var circle3OffsetX: CGFloat = 125
     @State private var circle3OffsetY: CGFloat = 25
     @State private var circle3GradientColors: [Color] = [.orange.opacity(0.1), .pink.opacity(0.15)]
     
     var body: some View {
         ZStack {
             Circle()
                 .fill(
                     LinearGradient(gradient: Gradient(colors: circle1GradientColors), startPoint: .top, endPoint: .bottom)
                 )
                 .frame(width: circle1Width)
                 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                 .offset(x: circle1OffsetX, y: circle1OffsetY)
             
             Circle()
                 .fill(
                     LinearGradient(gradient: Gradient(colors: circle2GradientColors), startPoint: .top, endPoint: .bottom)
                 )
                 .frame(width: circle2Width)
                 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                 .offset(x: circle2OffsetX, y: circle2OffsetY)
             
             Circle()
                 .fill(
                     LinearGradient(gradient: Gradient(colors: circle3GradientColors), startPoint: .top, endPoint: .bottom)
                 )
                 .frame(width: circle3Width)
                 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                 .offset(x: circle3OffsetX, y: circle3OffsetY)
         }
         .onAppear {
             updateCircleProperties()
         }
     }
     
     func updateCircleProperties() {
         // Генерация случайных значений для параметров каждого круга
         circle1Width = CGFloat.random(in: 50...400)
         circle1OffsetX = CGFloat.random(in: -100...100)
         circle1OffsetY = CGFloat.random(in: -100...100)
         circle1GradientColors = [
             Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)).opacity(0.1),
             Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)).opacity(0.15)
         ]
         
         circle2Width = CGFloat.random(in: 50...400)
         circle2OffsetX = CGFloat.random(in: -100...100)
         circle2OffsetY = CGFloat.random(in: -100...100)
         circle2GradientColors = [
             Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)).opacity(0.1),
             Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)).opacity(0.15)
         ]
         
         circle3Width = CGFloat.random(in: 50...400)
         circle3OffsetX = CGFloat.random(in: -100...100)
         circle3OffsetY = CGFloat.random(in: -100...100)
         circle3GradientColors = [
             Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)).opacity(0.1),
             Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)).opacity(0.15)
         ]
     }
 }
 
 #Preview {
     HomeBG()
 }
 
 */
