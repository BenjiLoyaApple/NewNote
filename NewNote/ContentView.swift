//
//  ContentView.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State private var showIntro = false
    
    var body: some View {
        NavigationStack {
            /// Redirecting User Based on Log Status
            if logStatus {
              //   Intro()
                Home()
                    .accentColor(.primary)
            } else {
                HomeOnBoard()
            }
        }
    }
}

#Preview("English") {
    let preview = Preview(Note.self)
    let notes = Note.sampleNotes
    preview.addExamples(notes)
    return ContentView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "EN"))
}
