//
//  ContributorCardTests.swift
//  
//
//  Created by Aye Chan on 3/12/23.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import ContributorUI

class ContributorCardTests: XCTestCase {
    var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return session
    }

    var github: GitHub {
        let githubAPI = GitHubAPI()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let url = Bundle.module.url(forResource: "contributors", withExtension: "json")!
            return (response, try Data(contentsOf: url))
        }
        return Networking(on: githubAPI, session: session)
    }

    override class func setUp() {
        MockURLProtocol.requestHandler = nil
    }

    override class func tearDown() {
        MockURLProtocol.requestHandler = nil
    }

    func testContributorCardState() throws {
        let sut = ContributorCard(owner: "owner", repo: "repo", github: github)
        let exp = sut.inspection.inspect(after: 0.5) { view in
            let card = try view.actualView()
            XCTAssertEqual(floor(card.width), 980)
            XCTAssertNil(card.selection)
            XCTAssertEqual(card.location, .zero)
            XCTAssertEqual(card.labelHeight, .zero)
            XCTAssertEqual(card.viewModel.contributors.count, 10)
        }
        ViewHosting.host(view: sut.frame(width: 1000, height: 1000))
        wait(for: [exp], timeout: 1)
    }

    func testContributorCardDefaultConfiguration() throws {
        let sut = ContributorCard(owner: "owner", repo: "repo", github: github)
        let configuration = sut.configuration
        XCTAssertEqual(configuration.padding, 10)
        XCTAssertEqual(configuration.spacing, 8)
        XCTAssertEqual(configuration.countPerRow, 8)
        XCTAssertEqual(configuration.cornerRadius, 15)
        XCTAssertEqual(configuration.includesAnonymous, false)
        XCTAssertEqual(configuration.avatarStyle, .circle)
        XCTAssertEqual(configuration.borderStyle, .borderless)
        XCTAssertEqual(configuration.maximumDisplayCount, 30)
        XCTAssertEqual(configuration.minimumCardRowCount, 3)
        XCTAssertEqual(configuration.labelStyle, .default)
    }

    func testContributorCardConfigurationModifiers() throws {
        let sut = ContributorCard(owner: "owner", repo: "repo", github: github)
            .padding(20)
            .spacing(10)
            .backgroundStyle(.red)
            .cornerRadius(20)
            .countPerRow(6)
            .includesAnonymous(true)
            .avatarStyle(.roundedRectangle(cornerRadius: 10))
            .borderStyle(.bordered(color: .blue, lineWidth: 5))
            .maximumDisplayCount(50)
            .minimumCardRowCount(4)
            .labelStyle(.custom(font: .headline, color: .brown, backgroundStyle: .white))
        let exp = sut.inspection.inspect(after: 0.5) { view in
            let card = try view.actualView()
            let configuration = card.configuration
            XCTAssertEqual(configuration.padding, 20)
            XCTAssertEqual(configuration.spacing, 10)
            XCTAssertEqual(configuration.countPerRow, 6)
            XCTAssertEqual(configuration.cornerRadius, 20)
            XCTAssertEqual(configuration.includesAnonymous, true)
            XCTAssertEqual(configuration.avatarStyle, .roundedRectangle(cornerRadius: 10))
            XCTAssertEqual(configuration.borderStyle, .bordered(color: .blue, lineWidth: 5))
            XCTAssertEqual(configuration.maximumDisplayCount, 50)
            XCTAssertEqual(configuration.minimumCardRowCount, 4)
            XCTAssertEqual(configuration.labelStyle, .custom(font: .headline, color: .brown, backgroundStyle: .white))
            XCTAssertEqual(floor(card.width), 960)
            XCTAssertEqual(card.viewModel.contributors.count, 10)
        }
        ViewHosting.host(view: sut.frame(width: 1000, height: 1000))
        wait(for: [exp], timeout: 5)
    }
}

