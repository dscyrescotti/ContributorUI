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
        var backgroundStyle: AnyShapeStyle

        public init<S: ShapeStyle>(
            padding: CGFloat,
            spacing: CGFloat,
            countPerRow: Int,
            cornerRadius: CGFloat,
            backgroundStyle: S
        ) {
            self.padding = padding
            self.spacing = spacing
            self.countPerRow = countPerRow
            self.cornerRadius = cornerRadius
            self.backgroundStyle = AnyShapeStyle(backgroundStyle)
        }
    }
}

public extension ContributorCard.Configuration {
    static let `default` = ContributorCard.Configuration(
        padding: 10,
        spacing: 8,
        countPerRow: 8,
        cornerRadius: 15,
        backgroundStyle: Material.regularMaterial
    )
}
