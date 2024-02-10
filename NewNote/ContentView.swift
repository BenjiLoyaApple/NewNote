//
//  ContentView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Just Journal")
        }
    }
}

#Preview {
    ContentView()
}
