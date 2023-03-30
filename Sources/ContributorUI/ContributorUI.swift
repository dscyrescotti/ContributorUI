//
//  ContributorUI.swift
//  
//
//  Created by Aye Chan on 3/17/23.
//

import Foundation

class ContributorUIBundle { }

public struct ContributorUI {
    static var TOKEN_KEY: String?

    static public func configure(with token: String?) {
        TOKEN_KEY = token
    }
}

public extension Bundle {
    static var contribtorUI: Bundle = {
        let bundleName = "ContributorUI_ContributorUI"

        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: ContributorUIBundle.self).resourceURL,
            Bundle(for: ContributorUIBundle.self).resourceURL?.deletingLastPathComponent(),
            Bundle.main.bundleURL,
            Bundle(for: ContributorUIBundle.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
            Bundle(for: ContributorUIBundle.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]

        for candidate in candidates {
            let bundlePathiOS = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePathiOS.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named ContributorUI_ContributorUI")
    }()
}
