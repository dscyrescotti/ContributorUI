//
//  SizePreferenceKey.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import Foundation

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

struct SizeModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            }
    }

}

extension View {
    func onChangeSize(_ handler: @escaping (CGSize) -> Void) -> some View {
        self
            .modifier(SizeModifer())
            .onPreferenceChange(SizePreferenceKey.self) { value in
                handler(value)
            }
    }
}
