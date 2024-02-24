//
//  ModelInto.swift
//  ios17
//
//  Created by Benji Loya on 04.11.2023.
//

import SwiftUI

struct IntroModel: Identifiable {
    var id: UUID = .init()
    var text: String
    var textColor: Color
    var circleColor: Color
    var bgColor: Color
    var circleOffset: CGFloat = 0
    var textOffset: CGFloat = 0
}

    /// Sample Intro
var sampleIntros: [IntroModel] = [
    .init(text: "Create", textColor: ColorManager.textColor, circleColor: ColorManager.textColor, bgColor: ColorManager.bgColor),
    .init(text: "Save", textColor: ColorManager.textColor, circleColor: ColorManager.textColor, bgColor: ColorManager.bgColor),
    .init(text: "Organize", textColor: ColorManager.textColor, circleColor: ColorManager.textColor, bgColor: ColorManager.bgColor),
    .init(text: "Organize", textColor: ColorManager.textColor, circleColor: ColorManager.textColor, bgColor: ColorManager.bgColor)
    
]
