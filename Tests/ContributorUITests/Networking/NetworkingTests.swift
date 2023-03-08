//
//  NetworkTests.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import XCTest
@testable import ContributorUI

final class NetworkingTests: XCTestCase {
    var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return session
    }

    override class func setUp() {
        MockURLProtocol.requestHandler = nil
    }

    override class func tearDown() {
        MockURLProtocol.requestHandler = nil
    }

    func testNetworkingWithSuccess() async throws {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let url = Bundle.module.url(forResource: "contributors", withExtension: "json")!
            return (response, try Data(contentsOf: url))
        }
        let network = Networking(on: github, session: session)
        let result = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        XCTAssertEqual(result.count, 10)
        XCTAssertEqual(result[0].login, "phausler")
    }

    func testNetworkingWithDecodingFailure() async {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let network = Networking(on: github, session: session)
        do {
            let _ = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        } catch {
            XCTAssertNotNil(error as? DecodingError)
        }
    }

    func testNetworkingWithAPIError() async {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            throw APIError.invalidURL
        }
        let network = Networking(on: github, session: session)
        do {
            let _ = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        } catch let error as NSError {
            XCTAssertEqual(error.domain, "ContributorUI.APIError")
        }
    }
}
