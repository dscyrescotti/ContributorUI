//
//  ContributorListTests.swift
//  
//
//  Created by Aye Chan on 3/16/23.
//

import XCTest
import SwiftUI
import Kingfisher
import ViewInspector
@testable import ContributorUI

class ContributorListTests: XCTestCase {
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

    func loadSwiftContributors(with file: String = "contributors") {
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

    func testContributorListInit() throws {
        let sut = ContributorList(owner: "owner", repo: "repo")
        let configuration = sut.configuration
        XCTAssertNil(configuration.title)
        XCTAssertEqual(configuration.avatarStyle, .circle)
        XCTAssertEqual(configuration.listStyle, .table)
        XCTAssertFalse(configuration.showsCommits)
        XCTAssertFalse(configuration.hidesRepoLink)
        XCTAssertEqual(configuration.navigationTitle, "owner/repo")
    }

    func testContributorListConfiguration() throws {
        let sut = ContributorList(owner: "owner", repo: "repo", github: github)
            .navigationTitle("Meet Our Creators")
            .avatarStyle(.rectangle)
            .showsCommits(true)
            .hidesRepoLink(true)
            .contributorListStyle(.grid)
        let configuration = sut.configuration
        XCTAssertEqual(configuration.title, "Meet Our Creators")
        XCTAssertEqual(configuration.avatarStyle, .rectangle)
        XCTAssertEqual(configuration.listStyle, .grid)
        XCTAssertTrue(configuration.showsCommits)
        XCTAssertTrue(configuration.hidesRepoLink)
    }

    func testContributorListLayoutWithContainer() throws {
        let sut = ContributorList(owner: "owner", repo: "repo", github: github)
        loadSwiftContributors()
        let exp = sut.inspection.inspect(after: 1) { view in
            let navigationStack = try view.navigationStack()
            let container = try navigationStack.view(TableListContainer.self, 0)
            let toolbar = try container.toolbar()
            let cancel = try toolbar.find(button: "Close")
            try cancel.tap()
        }

        ViewHosting.host(view: sut.frame(width: 390, height: 844))
        wait(for: [exp], timeout: 2)
    }

    func testContributorListLayoutWithErrorPrompt() throws {
        let sut = ContributorList(owner: "owner", repo: "repo", github: github)
        setUpErrorCode(with: 500)
        let exp = sut.inspection.inspect(after: 1) { view in
            let navigationStack = try view.navigationStack()
            let errorPrompt = try navigationStack.view(ErrorPrompt.self, 0)
            let toolbar = try errorPrompt.toolbar()
            XCTAssertNoThrow(try toolbar.find(button: "Close"))
            let button = try errorPrompt.find(button: "Retry")
            try button.tap()
        }
        ViewHosting.host(view: sut.frame(width: 390, height: 844))
        wait(for: [exp], timeout: 2)
    }

    func testContributorListLayoutWithTableListContainer() throws {
        let sut = ContributorList(owner: "owner", repo: "repo", github: github)
            .showsCommits(true)
            .hidesRepoLink(true)
        loadSwiftContributors()
        let exp = sut.inspection.inspect(after: 1) { view in
            let sut = try view.actualView()
            let container = try view.navigationStack().view(TableListContainer.self, 0)
            let list = try container.list()
            let forEach = try list.forEach(0)
            XCTAssertEqual(forEach.count, 10)
            XCTAssertNoThrow(try list.emptyView(1))
            let listStyle = try list.listStyle()
            XCTAssertNotNil(listStyle as? PlainListStyle)

            let cell = try forEach.hStack(0)
            XCTAssertEqual(try cell.spacing(), 10)

            let kfImage = try cell.view(KFImage.self, 0)
            let frame = try kfImage.fixedFrame()
            XCTAssertEqual(frame.width, 50)
            XCTAssertEqual(frame.height, 50)

            let vStack = try cell.vStack(1)
            XCTAssertEqual(try vStack.spacing(), 5)
            XCTAssertEqual(try vStack.alignment(), .leading)

            let loginLabel = try vStack.text(0)
            XCTAssertEqual(try loginLabel.string(), sut.viewModel.contributors[0].login)
            XCTAssertEqual(try loginLabel.attributes().font(), .headline)

            let commitLabel = try vStack.text(1)
            XCTAssertEqual(try commitLabel.string(), "\(sut.viewModel.contributors[0].contributions) commits")
            XCTAssertEqual(try commitLabel.attributes().font(), .caption)
        }
        ViewHosting.host(view: sut.frame(width: 390, height: 844))
        wait(for: [exp], timeout: 2)
    }

    func testContributorListLayoutWithGridListContainer() throws {
        let sut = ContributorList(owner: "owner", repo: "repo", github: github)
            .showsCommits(true)
            .contributorListStyle(.grid)
        loadSwiftContributors()
        let exp = sut.inspection.inspect(after: 1) { view in
            let sut = try view.actualView()
            let container = try view.navigationStack().view(GridListContainer.self, 0)
            let scrollView = try container.geometryReader().scrollView()
            let grid = try scrollView.lazyVGrid()
            let forEach = try grid.forEach(0)
            XCTAssertEqual(forEach.count, 10)
            XCTAssertNoThrow(try grid.emptyView(1))

            let cell = try forEach.geometryReader(0)
            let vStack = try cell.vStack()
            XCTAssertEqual(try vStack.spacing(), 10)

            XCTAssertNoThrow(try vStack.view(KFImage.self, 0))

            let labelStack = try vStack.vStack(1)
            XCTAssertNil(try labelStack.spacing())
            XCTAssertEqual(try labelStack.alignment(), .center)

            let loginLabel = try labelStack.text(0)
            XCTAssertEqual(try loginLabel.string(), sut.viewModel.contributors[0].login)
            XCTAssertEqual(try loginLabel.attributes().font(), .caption.bold())
            XCTAssertEqual(try loginLabel.lineLimit(), 1)

            let commitLabel = try labelStack.text(1)
            XCTAssertEqual(try commitLabel.string(), "\(sut.viewModel.contributors[0].contributions) commits")
            XCTAssertEqual(try commitLabel.attributes().font(), .caption2)
            XCTAssertEqual(try commitLabel.lineLimit(), 1)
        }
        ViewHosting.host(view: sut.frame(width: 390, height: 844))
        wait(for: [exp], timeout: 2)
    }

    func testContributorListLayoutWithTablePlaceholder() throws {
        let viewModel = TestContributroListViewModel(github: github)
        let sut = ContributorList(configuration: ContributorList.Configuration(repo: "owner", owner: "repo"), viewModel: StateObject(wrappedValue: viewModel))
            .showsCommits(true)
        loadSwiftContributors()
        let exp = sut.inspection.inspect(after: 1) { view in
            let container = try view.navigationStack().view(TableListContainer.self, 0)
            let list = try container.list()
            let vStack = try list.vStack(1)
            let forEach = try vStack.forEach(0)
            XCTAssertEqual(try vStack.alignment(), .leading)
            XCTAssertEqual(forEach.count, 4)

            let placeholders = forEach.findAll(ViewType.HStack.self)
            XCTAssertEqual(placeholders.count, 4)
            let dividers = forEach.findAll(ViewType.Divider.self)
            XCTAssertEqual(dividers.count, 3)

            let placeholder = placeholders[0]
            XCTAssertNoThrow(try placeholder.shape(0))
            XCTAssertEqual(try placeholder.shape(0).foregroundColor(), .gray.opacity(0.4))

            let placeholderVStack = try placeholder.vStack(1)
            XCTAssertEqual(try placeholderVStack.alignment(), .leading)
            XCTAssertEqual(try placeholderVStack.spacing(), 5)

            let capsule1 = try placeholderVStack.shape(0)
            let capsule2 = try placeholderVStack.shape(1)
            XCTAssertEqual(try capsule1.foregroundColor(), .gray.opacity(0.4))
            XCTAssertEqual(try capsule2.foregroundColor(), .gray.opacity(0.4))
        }
        ViewHosting.host(view: sut.frame(width: 390, height: 844))
        wait(for: [exp], timeout: 2)
    }

    func testContributorListLayoutWithGridPlaceholder() throws {
        let viewModel = TestContributroListViewModel(github: github)
        let sut = ContributorList(configuration: ContributorList.Configuration(repo: "owner", owner: "repo"), viewModel: StateObject(wrappedValue: viewModel))
            .showsCommits(true)
            .contributorListStyle(.grid)
        loadSwiftContributors()
        let exp = sut.inspection.inspect(after: 1) { view in
            let container = try view.navigationStack().view(GridListContainer.self, 0)
            let scrollView = try container.geometryReader().scrollView()
            let grid = try scrollView.lazyVGrid()
            let forEach = try grid.forEach(1)
            XCTAssertEqual(forEach.count, 4)

            let placeholders = forEach.findAll(ViewType.GeometryReader.self)
            XCTAssertEqual(placeholders.count, 4)

            let placeholder = try placeholders[0].vStack()
            XCTAssertNoThrow(try placeholder.shape(0))
            XCTAssertEqual(try placeholder.shape(0).foregroundColor(), .gray.opacity(0.4))

            let placeholderVStack = try placeholder.vStack(1)
            XCTAssertEqual(try placeholderVStack.spacing(), 2)

            let capsule1 = try placeholderVStack.shape(0)
            let capsule2 = try placeholderVStack.shape(1)
            XCTAssertEqual(try capsule1.foregroundColor(), .gray.opacity(0.4))
            XCTAssertEqual(try capsule2.foregroundColor(), .gray.opacity(0.4))
        }
        ViewHosting.host(view: sut.frame(width: 390, height: 844))
        wait(for: [exp], timeout: 2)
    }
}
