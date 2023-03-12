//
//  LabelStyle.swift
//  
//
//  Created by Aye Chan on 3/11/23.
//

import SwiftUI
import Foundation

public struct LabelStyle {
    let font: Font
    let color: Color
    let backgroundStyle: AnyShapeStyle

    init<S: ShapeStyle>(font: Font = .caption, color: Color = .primary, backgroundStyle: S = Material.regularMaterial) {
        self.font = font
        self.color = color
        self.backgroundStyle = AnyShapeStyle(backgroundStyle)
    }
}

public extension LabelStyle {
    static var `default`: LabelStyle = LabelStyle()
    
    static func custom<S: ShapeStyle>(font: Font, color: Color, backgroundStyle: S) -> LabelStyle {
        LabelStyle(font: font, color: color, backgroundStyle: backgroundStyle)
    }
}
