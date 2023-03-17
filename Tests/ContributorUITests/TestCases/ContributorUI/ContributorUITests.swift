//
//  File.swift
//  
//
//  Created by Aye Chan on 3/17/23.
//

import XCTest
@testable import ContributorUI

class ContributorUITests: XCTestCase {
    var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return session
    }

    var github: GitHub {
        let githubAPI = GitHubAPI()
        return Networking(on: githubAPI, session: session)
    }

    override class func setUp() {
        ContributorUI.TOKEN_KEY = nil
        MockURLProtocol.requestHandler = nil
    }

    override class func tearDown() {
        ContributorUI.TOKEN_KEY = nil
        MockURLProtocol.requestHandler = nil
    }

    func testContributorUIConfiguration() async throws {
        ContributorUI.configure(with: "token-key")
        XCTAssertEqual(ContributorUI.TOKEN_KEY, "token-key")
        let github = github
        MockURLProtocol.requestHandler = { request in
            let headers = request.allHTTPHeaderFields
            XCTAssertNotNil(headers)
            let value = headers!["Authorization"]
            XCTAssertNotNil(value)
            XCTAssertEqual(value, "Bearer token-key")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let url = Bundle.module.url(forResource: "contributors", withExtension: "json")!
            return (response, try Data(contentsOf: url))
        }
        _ = try await github.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repo"), parameters: [:])
    }
}
