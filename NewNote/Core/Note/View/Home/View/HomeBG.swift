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
