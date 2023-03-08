//
//  APITests.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import XCTest
@testable import ContributorUI

final class APITests: XCTestCase {
    func testGitHubAPI() throws {
        let github = GitHubAPI()
        let baseURL = github.baseURL
        let headers = github.headers
        XCTAssertNotNil(baseURL)
        XCTAssertEqual(baseURL, URL(string: "https://api.github.com/"))
        XCTAssertEqual(headers.count, 2)
        XCTAssertEqual(headers["Accept"], "application/vnd.github+json")
        XCTAssertEqual(headers["X-GitHub-Api-Version"], "2022-11-28")
        let request = try github.urlRequest(.listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        XCTAssertEqual(request.url, URL(string: "https://api.github.com/repos/owner/repository/contributors?"))
        let requestWithQueries = try github.urlRequest(.listRepositoryContributors(owner: "owner", repo: "repository"), parameters: ["per_page":"20"])
        XCTAssertEqual(requestWithQueries.url, URL(string: "https://api.github.com/repos/owner/repository/contributors?per_page=20"))
    }

    func testAPIError() throws {
        let mock = MockAPI()
        let baseURL = mock.baseURL
        let headers = mock.headers
        XCTAssertNotNil(baseURL)
        XCTAssertEqual(baseURL, URL(string: "http://api.test.com/"))
        XCTAssertEqual(headers.count, 1)
        XCTAssertEqual(headers["Accept"], "application/json")
        XCTAssertThrowsError(try mock.urlRequest(.dummy, parameters: [:]))
    }
}
