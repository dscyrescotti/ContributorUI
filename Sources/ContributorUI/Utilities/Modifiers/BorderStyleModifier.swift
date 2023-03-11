//
//  BorderStyleModifier.swift
//  
//
//  Created by Aye Chan on 3/11/23.
//

import SwiftUI
import Foundation

struct BorderStyleModifier: ViewModifier {
    let cornerRadius: CGFloat
    let borderStyle: BorderStyle

    func body(content: Content) -> some View {
        switch borderStyle {
        case .borderless: content
        case let .bordered(color, lineWidth):
            content
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(color, lineWidth: lineWidth)
                }
        }
    }
}

extension View {
    func borderStyle(with style: BorderStyle, cornerRadius: CGFloat) -> some View {
        modifier(BorderStyleModifier(cornerRadius: cornerRadius, borderStyle: style))
    }
}
