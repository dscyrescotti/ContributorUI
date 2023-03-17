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
        }
    }
}
