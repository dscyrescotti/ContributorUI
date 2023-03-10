//
//  ContentView.swift
//  Demo
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import ContributorUI

struct ContentView: View {
    var body: some View {
        ContributorCard(owner: "apple", repo: "swift")
            .padding(20)
            .backgroundStyle(.thinMaterial)
            .countPerRow(10)
            .maximumDisplayCount(28)
            .includesAnonymous(false)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
