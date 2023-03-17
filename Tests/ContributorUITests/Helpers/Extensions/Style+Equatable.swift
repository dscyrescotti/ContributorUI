//
//  Style+Equatable.swift
//  
//
//  Created by Aye Chan on 3/12/23.
//

import Foundation
import ViewInspector
@testable import ContributorUI

extension AvatarStyle: Equatable {
    public static func == (lhs: AvatarStyle, rhs: AvatarStyle) -> Bool {
        switch (lhs, rhs) {
        case (.circle, .circle):
            return true
        case (.rectangle, .rectangle):
            return true
        case let (.roundedRectangle(lhsRadius), .roundedRectangle(rhsRadius)):
            return lhsRadius == rhsRadius
        default:
            return false
        }
    }
}

extension BorderStyle: Equatable {
    public static func == (lhs: BorderStyle, rhs: BorderStyle) -> Bool {
        switch (lhs, rhs) {
        case (.borderless, .borderless):
            return true
        case let (.bordered(lhsColor, lhsLineWidth), .bordered(rhsColor, rhsLineWidth)):
            return lhsColor == rhsColor && rhsLineWidth == lhsLineWidth
        default:
            return false
        }
    }
}

extension LabelStyle: Equatable {
    public static func == (lhs: LabelStyle, rhs: LabelStyle) -> Bool {
        return lhs.font == rhs.font && lhs.color == rhs.color
    }
}
