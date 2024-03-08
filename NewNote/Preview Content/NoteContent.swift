//
//  NoteContent.swift
//  NewNote
//
//  Created by Benji Loya on 10.02.2024.
//

import Foundation
import SwiftUI

extension Note {
    static var sampleNotes: [Note] {
        [
            Note(title: "New York", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", image: Data.named("cali"), tag: .red),
            Note(title: "San Diego", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum ", image: Data.named("cali2"), tag: .orange),
            Note(title: "Chicago", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", tag: .purple, isfavorite: true),
            Note(title: "Huston", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", tag: .personal),
            Note(title: "Dallas", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", tag: .blue),
            Note(title: "New Mexico", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum", image: Data.named("cali2"), tag: .gray, isfavorite: true),
            Note(title: "New York", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", image: Data.named("cali"), tag: .red),
            Note(title: "San Diego", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum ", image: Data.named("cali2"), tag: .orange),
            Note(title: "Chicago", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", tag: .purple, isfavorite: true),
            Note(title: "Huston", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", tag: .personal),
            Note(title: "Dallas", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", tag: .blue),
            Note(title: "New Mexico", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum", image: Data.named("cali2"), tag: .gray, isfavorite: true)
            
        ]
    }
}

extension Data {
    static func named(_ name: String) -> Data? {
        return UIImage(named: name)?.pngData()
    }
}

extension URL {
    static func named(_ name: String) -> URL? {
        return Bundle.main.url(forResource: name, withExtension: "mp4")
    }
}
