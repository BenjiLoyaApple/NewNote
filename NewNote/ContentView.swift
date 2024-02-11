//
//  ContentView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
     ///    Redirecting User Based on Log Status
        if logStatus {
//            IntosView()
            Home()
                .navigationTitle("Just Journal")
        } else {
            HomeOnBoard()
        }
    }
}

#Preview {
    ContentView()
}
