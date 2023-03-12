//
//  AvatarStyle.swift
//  
//
//  Created by Dscyre Scotti on 11/03/2023.
//

import SwiftUI
import Foundation

public enum AvatarStyle {
    case circle
    case rectangle
    case roundedRectangle(cornerRadius: CGFloat)
}

extension AvatarStyle {
    func shape() -> AnyShape {
        switch self {
        case .circle:
            return AnyShape(Circle())
        case .rectangle:
            return AnyShape(Rectangle())
        case let .roundedRectangle(cornerRadius):
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
