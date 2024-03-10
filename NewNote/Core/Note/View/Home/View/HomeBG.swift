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
            GradientCircle(colors: [
                .indigo.opacity(0.1),
                .purple.opacity(0.15)],
                           startPoint: .top,
                           endPoint: .bottom,
                           radius: 75, alignment: .bottomTrailing,
                           xOffset: 25,
                           yOffset: -505)
            GradientCircle(colors: [
                .blue.opacity(0.1),
                .mint.opacity(0.15)],
                           startPoint: .top,
                           endPoint: .bottom,
                           radius: 140, alignment: .topLeading,
                           xOffset: -85,
                           yOffset: 220)
            GradientCircle(colors: [
                .orange.opacity(0.1),
                .pink.opacity(0.15)],
                           startPoint: .top,
                           endPoint: .bottom,
                           radius: 170, alignment: .bottomTrailing,
                           xOffset: 125,
                           yOffset: 25)
        }
    }
}


#Preview {
    HomeBG()
}

//MARK: - View Circle
struct GradientCircle: View {
    let colors: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    let radius: CGFloat
    let alignment: Alignment
    let xOffset: CGFloat
    let yOffset: CGFloat
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
            )
            .frame(width: radius * 2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .offset(x: xOffset, y: yOffset)
    }
}
