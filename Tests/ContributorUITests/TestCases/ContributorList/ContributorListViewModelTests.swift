//
//  ContributorListViewModelTests.swift
//  
//
//  Created by Aye Chan on 3/17/23.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import ContributorUI

class ContributorListViewModelTests: XCTestCase {
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

    func testContributorListViewModel() async throws {
        let configuration = ContributorList.Configuration(repo: "repo", owner: "owner")
        let viewModel = ContributorListViewModel(github: github)
        loadSwiftContributors(with: "contributors-swift-1")
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.page, 1)

        await viewModel.loadContributors(with: configuration)
        let contributor = Contributor(id: 20177294, type: "User", login: "meg-gupta", nodeId: "MDQ6VXNlcjIwMTc3Mjk0", htmlURL: "", siteAdmin: false, avatarURL: "https://avatars.githubusercontent.com/u/20177294?v=4", contributions: 478)
        XCTAssertEqual(viewModel.lastId, contributor.id)
        XCTAssertEqual(viewModel.contributors.count, 50)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.page, 2)
        XCTAssertEqual(viewModel.state, .idle)

        loadSwiftContributors(with: "contributors-swift-2")
        let contributor1 = Contributor(id: 15467072, type: "User", login: "swift-ci", nodeId: "MDQ6VXNlcjE1NDY3MDcy", htmlURL: "", siteAdmin: false, avatarURL: "https://avatars.githubusercontent.com/u/15467072?v=4", contributions: 28740)
        await viewModel.loadNextPageIfReachToBottom(contributor1, with: configuration)
        XCTAssertEqual(viewModel.lastId, contributor.id)
        XCTAssertEqual(viewModel.contributors.count, 50)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.page, 2)
        XCTAssertEqual(viewModel.state, .idle)

        await viewModel.loadNextPageIfReachToBottom(contributor, with: configuration)
        XCTAssertEqual(viewModel.lastId, 15270369)
        XCTAssertEqual(viewModel.contributors.count, 100)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.page, 3)
        XCTAssertEqual(viewModel.state, .idle)
    }

    func testContributorListViewModelWithNoMoreLoading() async throws {
        let configuration = ContributorList.Configuration(repo: "repo", owner: "owner")
        let viewModel = ContributorListViewModel(github: github)
        loadSwiftContributors(with: "contributors")
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.page, 1)

        await viewModel.loadContributors(with: configuration)
        let contributor = Contributor(id: 112310, type: "User", login: "MaxDesiatov", nodeId: "MDQ6VXNlcjExMjMxMA==", htmlURL: "", siteAdmin: false, avatarURL: "https://avatars.githubusercontent.com/u/112310?v=4", contributions: 2)
        XCTAssertEqual(viewModel.lastId, contributor.id)
        XCTAssertEqual(viewModel.contributors.count, 10)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.page, 2)
        XCTAssertEqual(viewModel.state, .end)

        await viewModel.loadNextPageIfReachToBottom(contributor, with: configuration)
        XCTAssertEqual(viewModel.lastId, contributor.id)
        XCTAssertEqual(viewModel.contributors.count, 10)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.page, 2)
        XCTAssertEqual(viewModel.state, .end)
    }

    func testContributorListViewModelWithError() async throws {
        let configuration = ContributorList.Configuration(repo: "repo", owner: "owner")
        let viewModel = ContributorListViewModel(github: github)
        setUpErrorCode(with: 500)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.error, .unknownError)

        setUpErrorCode(with: 404)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.error, .notFoundError)

        setUpErrorCode(with: 403)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.error, .forbiddenError)

        setUpErrorCode(with: 204)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.error, .emptyError)

        setUpErrorCode(with: 200)
        await viewModel.loadContributors(with: configuration)
        XCTAssertEqual(viewModel.contributors.count, 0)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(viewModel.error, .unknownError)
    }
}
