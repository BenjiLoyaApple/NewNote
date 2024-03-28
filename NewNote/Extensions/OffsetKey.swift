//
//  OffsetKey.swift
//  NewNote
//
//  Created by Benji Loya on 11.02.2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey{
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View{
    @ViewBuilder
    func offset(name: String = "SCROLL",completion: @escaping (CGRect)->())->some View{
        self
            .overlay {
                GeometryReader{
                    let rect = $0.frame(in: .named(name))
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}
