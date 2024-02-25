//
//  NewNoteApp.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct NewNoteApp: App {
    
    var body: some Scene {
        WindowGroup {
                ContentView()
                //MARK: - TipKit
                    .task {
                        // Configure and load your tips at app launch.
                        try? Tips.configure([
                            //  .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
            }
        }
        .modelContainer(for: Note.self)
    }
}
