//
//  ContributorCard+Configuration.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import Foundation

extension ContributorCard {
    public struct Configuration: Equatable {
        public static func == (lhs: ContributorCard.Configuration, rhs: ContributorCard.Configuration) -> Bool {
            return lhs.includesAnonymous == rhs.includesAnonymous && lhs.maximumDisplayCount == rhs.maximumDisplayCount
        }

        let repo: String
        let owner: String
        var padding: CGFloat
        var spacing: CGFloat
        var countPerRow: Int
        var cornerRadius: CGFloat
        var labelStyle: LabelStyle
        var includesAnonymous: Bool
        var avatarStyle: AvatarStyle
        var borderStyle: BorderStyle
        var maximumDisplayCount: Int
        var minimumCardRowCount: Int
        var backgroundStyle: AnyShapeStyle

        public init<S: ShapeStyle>(
            repo: String,
            owner: String,
            padding: CGFloat = 10,
            spacing: CGFloat = 8,
            countPerRow: Int = 8,
            cornerRadius: CGFloat = 15,
            labelStyle: LabelStyle = .default,
            includesAnonymous: Bool = false,
            avatarStyle: AvatarStyle = .circle,
            borderStyle: BorderStyle = .borderless,
            maximumDisplayCount: Int = 30,
            minimumCardRowCount: Int = 3,
            backgroundStyle: S = Material.regularMaterial
        ) {
            self.repo = repo
            self.owner = owner
            self.padding = padding
            self.spacing = spacing
            self.labelStyle = labelStyle
            self.avatarStyle = avatarStyle
            self.borderStyle = borderStyle
            self.countPerRow = countPerRow
            self.cornerRadius = cornerRadius
            self.includesAnonymous = includesAnonymous
            self.maximumDisplayCount = maximumDisplayCount
            self.minimumCardRowCount = minimumCardRowCount
            self.backgroundStyle = AnyShapeStyle(backgroundStyle)
        }
    }
}
