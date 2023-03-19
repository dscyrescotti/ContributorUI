//
//  DemoApp.swift
//  Demo
//
//  Created by Aye Chan on 3/9/23.
//

import SwiftUI
import ContributorUI

@main
struct DemoApp: App {
    init() {
        if let token = Bundle.main.object(forInfoDictionaryKey: "TOKEN_KEY") as? String, !token.isEmpty {
            ContributorUI.configure(with: token)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 1100, minHeight: 750)
                #endif
        }
        #if os(macOS)
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(DefaultWindowToolbarStyle())
        #endif
        #if os(macOS)
        WindowGroup("", for: Repository.self) { $repository in
            if let repository {
                ContributorList(owner: repository.owner, repo: repository.repo)
                    .contributorListStyle(.grid)
                    .frame(minWidth: 800, minHeight: 400)
            }
        }
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(DefaultWindowToolbarStyle())
        #endif
    }
}
