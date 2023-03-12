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
        let exp = sut.inspection.inspect(after: 1) { view in
            let card = try view.actualView()
            XCTAssertEqual(floor(card.width), 980)
            XCTAssertNil(card.selection)
            XCTAssertEqual(card.location, .zero)
            XCTAssertEqual(card.labelHeight, .zero)
        }
        ViewHosting.host(view: sut.frame(width: 1000, height: 1000))
        wait(for: [exp], timeout: 2)
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
        let exp = sut.inspection.inspect(after: 1) { view in
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
        wait(for: [exp], timeout: 2)
    }
    
    func testContributorCardLayout() throws {
        let sut = ContributorCard(owner: "owner", repo: "repo", github: github)
            .padding(20)
            .spacing(10)
            .backgroundStyle(.red)
            .cornerRadius(20)
            .countPerRow(6)
            .includesAnonymous(true)
            .avatarStyle(.rectangle)
            .borderStyle(.bordered(color: .blue, lineWidth: 5))
            .maximumDisplayCount(50)
            .minimumCardRowCount(4)
            .labelStyle(.custom(font: .headline, color: .brown, backgroundStyle: .white))
        let exp = sut.inspection.inspect(after: 1) { view in
            let size: CGFloat = (960 - 10 * 5) / 6
            let minimumHeight: CGFloat = size * 4 + 10 * 3
            
            let lazyVGrid = try view.lazyVGrid()
            let columns = try lazyVGrid.columns()
            let column = columns[1]
            XCTAssertEqual(columns.count, 6)
            XCTAssertEqual(column.size, .flexible())
            XCTAssertEqual(column.spacing, 10)
            XCTAssertEqual(try lazyVGrid.spacing(), 10)
            
            let frame = try lazyVGrid.flexFrame()
            XCTAssertEqual(floor(frame.minHeight), floor(minimumHeight))
            XCTAssertEqual(frame.alignment, .topLeading)
            
            let padding = try lazyVGrid.padding()
            XCTAssertEqual(padding.leading, 20)
            XCTAssertEqual(padding.trailing, 20)
            XCTAssertEqual(padding.top, 20)
            XCTAssertEqual(padding.bottom, 20)
            
            XCTAssertNoThrow(try lazyVGrid.background())
            
            let coordinateSpaceName = try lazyVGrid.coordinateSpaceName()
            XCTAssertEqual(coordinateSpaceName, "contributor-cards")
            
            let forEach = try lazyVGrid.forEach(0)
            XCTAssertEqual(forEach.count, 10)
            
            let asyncImage = try forEach.asyncImage(0)
            let fixedFrame = try asyncImage.fixedFrame()
            XCTAssertEqual(floor(fixedFrame.width), floor(size))
            XCTAssertEqual(floor(fixedFrame.height), floor(size))
        }
        ViewHosting.host(view: sut.frame(width: 1000, height: 1000))
        wait(for: [exp], timeout: 3)
    }
    
    func testContributorCardGesture() throws {
        let sut = ContributorCard(owner: "owner", repo: "repo", github: github)
            .padding(20)
            .spacing(10)
            .backgroundStyle(.red)
            .cornerRadius(20)
            .countPerRow(6)
            .includesAnonymous(true)
            .avatarStyle(.rectangle)
            .borderStyle(.bordered(color: .blue, lineWidth: 5))
            .maximumDisplayCount(50)
            .minimumCardRowCount(4)
            .labelStyle(.custom(font: .headline, color: .brown, backgroundStyle: .white))
        let exp1 = sut.inspection.inspect(after: 1.5) { view in
            let card = try view.actualView()
            XCTAssertNil(card.selection)
            let cell = try view.lazyVGrid().forEach(0).asyncImage(0)
            XCTAssertNoThrow(try cell.callOnTapGesture())
        }
        let exp2 = sut.inspection.inspect(after: 2) { view in
            let card = try view.actualView()
            
            XCTAssertNotNil(card.selection)
            XCTAssertEqual(card.selection, card.viewModel.contributors[0])
            
            let overlay = try view.lazyVGrid().overlay(0)
            let label = try overlay.find(text: card.viewModel.contributors[0].login)
            
            XCTAssertEqual(try label.attributes().font(), .headline)
            XCTAssertEqual(try label.attributes().foregroundColor(), .brown)
            XCTAssertEqual(try label.shadow().radius, 10)
            
            let padding = try label.padding()
            XCTAssertEqual(padding.top, 3)
            XCTAssertEqual(padding.bottom, 3)
            XCTAssertEqual(padding.leading, 6)
            XCTAssertEqual(padding.trailing, 6)
        }
        ViewHosting.host(view: sut.frame(width: 1000, height: 1000))
        wait(for: [exp1, exp2], timeout: 3)
    }
}

