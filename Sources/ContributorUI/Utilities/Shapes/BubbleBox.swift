//
//  BubbleBox.swift
//  
//
//  Created by Aye Chan on 3/11/23.
//

import SwiftUI

struct BubbleBox: Shape {
    let appendixSize: CGFloat = 8

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: .init(width: 5, height: 5))
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY + appendixSize))
        path.addLine(to: CGPoint(x: rect.midX + appendixSize / 1.5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - appendixSize / 1.5, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
