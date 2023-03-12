//
//  GitHub.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import Foundation

typealias GitHub = Networking<GitHubAPI>

extension GitHub {
    static var live = GitHub(on: GitHubAPI())
}
