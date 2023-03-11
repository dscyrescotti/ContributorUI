//
//  ShimmerModifier.swift
//  
//
//  Created by Aye Chan on 3/10/23.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var startPoint: UnitPoint = UnitPoint(x: -1, y: 0.5)
    @State private var endPoint: UnitPoint = .leading

    func body(content: Content) -> some View {
        ZStack {
            content
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .black, location: 0),
                    .init(color: .white, location: 0.5),
                    .init(color: .black, location: 1),
                ]),
                startPoint: startPoint,
                endPoint: endPoint
            )
            .opacity(0.3)
            .blendMode(.screen)
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    startPoint = .trailing
                    endPoint = UnitPoint(x: 2, y: 0.5)
                }
            }
        }
    }
}


extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}
