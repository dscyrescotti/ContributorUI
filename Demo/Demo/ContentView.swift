//
//  ContentView.swift
//  Demo
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import ContributorUI

struct ContentView: View {
    #if os(macOS)
    @Environment(\.openWindow) var openWindow
    #else
    @State var isPresent: Bool = false
    #endif
    var body: some View {
        VStack {
            HStack {
                Text("apple/swift")
                    .font(.headline)
                Spacer()
                Button {
                    #if os(macOS)
                    openWindow(id: "contributors")
                    #else
                    isPresent.toggle()
                    #endif
                } label: {
                    Text("See More")
                }
                .font(.subheadline)
            }
            ContributorCard(owner: "apple", repo: "swift")
                .padding(20)
                .backgroundStyle(.thinMaterial)
                .estimatedSize(38)
                .maximumDisplayCount(28)
        }
        .padding()
        #if os(iOS)
        .fullScreenCover(isPresented: $isPresent) {
            ContributorList(owner: "apple", repo: "swift")
                .contributorListStyle(.grid)
                .showsCommits(true)
        }
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
