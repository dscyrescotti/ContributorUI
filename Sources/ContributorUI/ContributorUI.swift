//
//  ContributorUI.swift
//  
//
//  Created by Aye Chan on 3/17/23.
//

import Foundation

public struct ContributorUI {
    static var TOKEN_KEY: String?

    private init() { }

    static public func configure(with token: String?) {
        TOKEN_KEY = token
    }
}
