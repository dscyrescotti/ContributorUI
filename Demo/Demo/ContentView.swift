//
//  ContentView.swift
//  Demo
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import ContributorUI

struct ContentView: View {
    @State var isPresent: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("apple/swift")
                    .font(.headline)
                Spacer()
                Button {
                    isPresent.toggle()
                } label: {
                    Text("See More")
                }
                .font(.subheadline)
            }
            ContributorCard(owner: "apple", repo: "swift")
                .padding(20)
                .backgroundStyle(.thinMaterial)
                .countPerRow(8)
                .maximumDisplayCount(28)
        }
        .padding()
        .fullScreenCover(isPresented: $isPresent) {
            ContributorList(owner: "apple", repo: "swift")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
