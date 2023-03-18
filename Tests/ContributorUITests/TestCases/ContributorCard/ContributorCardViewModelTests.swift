//
//  ContributorCardViewModelTests.swift
//  
//
//  Created by Aye Chan on 3/17/23.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import ContributorUI

class ContributorCardViewModelTests: XCTestCase {
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

    func loadSwiftContributors(with file: String) {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let url = Bundle.module.url(forResource: file, withExtension: "json")!
            return (response, try Data(contentsOf: url))
        }
    }

    func setUpErrorCode(with code: Int) {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
    }

    override class func setUp() {
        MockURLProtocol.requestHandler = nil
    }

    override class func tearDown() {
        MockURLProtocol.requestHandler = nil
    }

    func testContributorCardViewModel() async throws {
        let configuration = ContributorCard.Configuration(repo: "repo", owner: "owner")
        let viewModel = ContributorCardViewModel(github: github)
        loadSwiftContributors(with: "contributors")
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 10)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)

        loadSwiftContributors(with: "contributors-swift-1")
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 50)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }

    func testContributorCardViewModelWithError() async throws {
        let configuration = ContributorCard.Configuration(repo: "repo", owner: "owner")
        let viewModel = ContributorCardViewModel(github: github)
        setUpErrorCode(with: 500)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.error, .unknownError)

        setUpErrorCode(with: 404)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.error, .notFoundError)

        setUpErrorCode(with: 403)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.error, .forbiddenError)

        setUpErrorCode(with: 204)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.error, .emptyError)

        setUpErrorCode(with: 200)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.error, .unknownError)
    }
}
