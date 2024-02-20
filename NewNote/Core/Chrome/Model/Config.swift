//
//  Config.swift
//  NewNote
//
//  Created by Benji Loya on 18.02.2024.
//

import SwiftUI

struct Config: Identifiable{
    var id: String = UUID().uuidString
    var leading: Icon
    var center: Icon
    var trailing: Icon
}

struct Icon: Identifiable,Equatable{
    var id: String = UUID().uuidString
    var name: String = "placeholdertext.fill"
    var title: String = "Placeholder"
}

enum IconAlignment: String,CaseIterable{
    case leading = "Refresh"
    case center = "New Tab"
    case trailing = "Close Tab"
}
