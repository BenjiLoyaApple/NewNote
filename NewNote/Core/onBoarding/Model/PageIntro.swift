//
//  PageIntro.swift
//  NewNote
//
//  Created by Benji Loya on 11.02.2024.
//

import SwiftUI

struct PageIntro: Identifiable, Hashable {
    var id: UUID = .init()
    var introAssetImage: String
    var tittle: String
    var subTittle: String
    var displayysAction : Bool = false
}

var pageIntros: [PageIntro] = [
    .init(introAssetImage: "o1", tittle: "Wellcome to Just Journal:", subTittle: "The best way to capture thoughts."),
    .init(introAssetImage: "o2", tittle: "Professional entries:", subTittle: "Create, save, organize."),
    .init(introAssetImage: "o3", tittle: "Let's\nGet Started", subTittle: "Begin your journey with us.", displayysAction: true),
]
