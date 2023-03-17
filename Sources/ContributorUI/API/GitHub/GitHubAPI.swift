//
//  GitHubAPI.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import Foundation

struct GitHubAPI: API {
    let baseURL: URL? = URL(string: "https://api.github.com/")
    let headers: [String: String]

    init() {
        var headers = [
            "Accept":"application/vnd.github+json",
            "X-GitHub-Api-Version":"2022-11-28"
        ]
        if let tokenKey = ContributorUI.TOKEN_KEY {
            headers["Authorization"] = "Bearer \(tokenKey)"
        }
        self.headers = headers
    }

    enum Endpoints: Endpoint {
        case listRepositoryContributors(owner: String, repo: String)

        var path: String {
            switch self {
            case let .listRepositoryContributors(owner, repo):
                return "repos/\(owner)/\(repo)/contributors"
            }
        }
    }
}
