//
//  HoverModifier.swift
//  
//
//  Created by Aye Chan on 3/11/23.
//

import SwiftUI

struct HoverModifier: ViewModifier {
    let contributor: Contributor
    @Binding var selection: Contributor?
    @Binding var location: CGPoint
    @State var isHovering: Bool = false

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let x = geometry.frame(in: .named("contributor-cards")).midX
            let y = geometry.frame(in: .named("contributor-cards")).minY
            content
                .onTapGesture {
                    guard !isHovering else {
                        return
                    }
                    guard let selection else {
                        selection = contributor
                        location = CGPoint(x: x, y: y)
                        return
                    }
                    self.selection = selection == contributor ? nil : contributor
                    location = CGPoint(x: x, y: y)
                }
                .onHover { isHovering in
                    self.isHovering = isHovering
                    selection = isHovering ? contributor : nil
                    location = CGPoint(x: x, y: y)
                }
                .background {
                    Color.clear
                        .onAppear {
                            guard selection == contributor else { return }
                            location = CGPoint(x: x, y: y)
                        }
                        .id("\(x)-\(y)")
                }
        }
    }
}

extension View {
    func hovering(selection: Binding<Contributor?>, location: Binding<CGPoint>, contributor: Contributor) -> some View {
        modifier(HoverModifier(contributor: contributor, selection: selection, location: location))
    }
}
