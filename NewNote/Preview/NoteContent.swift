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
            Note(title: "New York", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", tag: .clear),
            Note(title: "San Diego", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.   Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.   Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", tag: .orange),
            Note(title: "Chicago", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", tag: .purple),
            Note(title: "Huston", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", tag: .personal),
            Note(title: "Dallas", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", tag: .blue),
            Note(title: "New Mexico", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum", tag: .gray)

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
