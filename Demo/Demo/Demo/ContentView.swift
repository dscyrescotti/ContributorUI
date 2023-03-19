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
    @State var repository: Repository?
    #endif

    let repositories: [Repository] = .all

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(repositories) { repository in
                    VStack {
                        HStack {
                            Text(repository.title)
                                .font(.headline)
                            Spacer()
                            Button {
                                #if os(macOS)
                                openWindow(id: "contributors")
                                #else
                                self.repository = repository
                                #endif
                            } label: {
                                Text("See More")
                            }
                            .font(.subheadline)
                        }
                        ContributorCard(owner: repository.owner, repo: repository.repo)
                            .padding(20)
                            .backgroundStyle(.thinMaterial)
                            .estimatedSize(38)
                            .minimumCardRowCount(1)
                            .maximumDisplayCount(30)
                    }
                    .padding()
                }
            }
        }
        #if os(iOS)
        .sheet(item: $repository) { repository in
            ContributorList(owner: repository.owner, repo: repository.repo)
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
