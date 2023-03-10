//
//  ContributorCard+Configuration.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import Foundation

extension ContributorCard {
    public struct Configuration {
        var padding: CGFloat
        var spacing: CGFloat
        var countPerRow: Int
        var cornerRadius: CGFloat
        var includesAnonymous: Bool
        var borderStyle: BorderStyle
        var maximumDisplayCount: Int
        var backgroundStyle: AnyShapeStyle

        public init<S: ShapeStyle>(
            padding: CGFloat = 10,
            spacing: CGFloat = 8,
            countPerRow: Int = 8,
            cornerRadius: CGFloat = 15,
            includesAnonymous: Bool = false,
            borderStyle: BorderStyle = .borderless,
            maximumDisplayCount: Int = 30,
            backgroundStyle: S = Material.regularMaterial
        ) {
            self.padding = padding
            self.spacing = spacing
            self.countPerRow = countPerRow
            self.cornerRadius = cornerRadius
            self.includesAnonymous = includesAnonymous
            self.borderStyle = borderStyle
            self.maximumDisplayCount = maximumDisplayCount
            self.backgroundStyle = AnyShapeStyle(backgroundStyle)
        }
    }
}
