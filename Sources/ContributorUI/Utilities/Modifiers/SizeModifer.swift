//
//  SizeModifer.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import Foundation

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
