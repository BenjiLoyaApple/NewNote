//
//  OffsetKey.swift
//  NewNote
//
//  Created by Benji Loya on 11.02.2024.
//

import SwiftUI

/// Offset Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
