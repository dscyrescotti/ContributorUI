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

    func testNetworkingWithInvalidURLError() async {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            throw APIError.invalidURL
        }
        let network = Networking(on: github, session: session)
        do {
            let _ = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        } catch let error as NSError {
            XCTAssertEqual(error.domain, "ContributorUI.APIError")
            let apiError = error.apiError()
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError?.errorDescription, "Invalid URL")
            XCTAssertEqual(apiError?.recoverySuggestion, "The URL is not valid to perform network request.")
        }
    }
    
    func testNetworkingWithNotFoundError() async {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let network = Networking(on: github, session: session)
        do {
            let _ = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        } catch let error as NSError {
            let apiError = error.apiError()
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError?.errorDescription, "Nothing Found")
            XCTAssertEqual(apiError?.recoverySuggestion, "There is no repository that you requested. Please provide a valid repository.")
        }
    }
    
    func testNetworkingWithEmptyError() async {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 204, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let network = Networking(on: github, session: session)
        do {
            let _ = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        } catch let error as NSError {
            let apiError = error.apiError()
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError?.errorDescription, "Nothing Existed")
            XCTAssertEqual(apiError?.recoverySuggestion, "There is no resource or data existed on the repository. Please provide a valid repository.")
        }
    }
    
    func testNetworkingWithUnknownError() async {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let network = Networking(on: github, session: session)
        do {
            let _ = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        } catch let error as NSError {
            let apiError = error.apiError()
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError?.errorDescription, "Something Went Wrong")
            XCTAssertEqual(apiError?.recoverySuggestion, "Something did not work out as expected. Please try again.")
        }
    }
    
    func testNetworkingWithForbiddenError() async {
        let github = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let network = Networking(on: github, session: session)
        do {
            let _ = try await network.fetch(Contributors.self, from: .listRepositoryContributors(owner: "owner", repo: "repository"), parameters: [:])
        } catch let error as NSError {
            let apiError = error.apiError()
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError?.errorDescription, "Access Denied")
            XCTAssertEqual(apiError?.recoverySuggestion, "You do not have an authorized access to the repository. Please provide a valid repository.")
        }
    }
}
