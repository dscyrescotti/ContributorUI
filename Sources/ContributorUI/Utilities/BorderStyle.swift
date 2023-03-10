//
//  BorderStyle.swift
//  
//
//  Created by Aye Chan on 3/10/23.
//

import SwiftUI

public enum BorderStyle {
    case borderless
    case bordered(color: Color, lineWidth: CGFloat = 1)
}

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
