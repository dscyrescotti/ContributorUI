//
//  AppKitSupportTests.swift
//  
//
//  Created by Dscyre Scotti on 18/03/2023.
//

#if canImport(AppKit)
import XCTest
@testable import ContributorUI

class AppKitSupportTests: XCTestCase {
    func testNSContributorCard() throws {
        let card = NSContributorCard(owner: "owner", repo: "repo") { configuration in
            configuration.avatarStyle = .rectangle
        }
        XCTAssertEqual(card.subviews.count, 1)
        let configuration = card.configuration
        XCTAssertEqual(configuration.padding, 10)
        XCTAssertEqual(configuration.spacing, 8)
        XCTAssertEqual(configuration.estimatedSize, 40)
        XCTAssertEqual(configuration.cornerRadius, 15)
        XCTAssertEqual(configuration.avatarStyle, .rectangle)
        XCTAssertEqual(configuration.borderStyle, .borderless)
        XCTAssertEqual(configuration.maximumDisplayCount, 30)
        XCTAssertEqual(configuration.minimumCardRowCount, 3)
        XCTAssertEqual(configuration.labelStyle, .default)
        
        let vc = ViewController()
        vc.view.addSubview(card)
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -20)
        ])
        let window = NSWindow(contentViewController: vc)
        window.makeKeyAndOrderFront(nil)
        XCTAssertEqual(vc.view.subviews.count, 1)
        XCTAssertEqual(vc.view.subviews[0], card)
    }

    func testNSContributorListController() throws {
        let vc = NSContributorListController(owner: "owner", repo: "repo") { configuration in
            configuration.avatarStyle = .rectangle
        }
        let window = NSWindow(contentViewController: vc)
        window.makeKeyAndOrderFront(nil)
        XCTAssertEqual(vc.view.subviews.count, 1)
        let configuration = vc.rootView.configuration
        XCTAssertNil(configuration.title)
        XCTAssertEqual(configuration.avatarStyle, .rectangle)
        XCTAssertEqual(configuration.listStyle, .table)
        XCTAssertFalse(configuration.showsCommits)
        XCTAssertFalse(configuration.hidesRepoLink)
        XCTAssertEqual(configuration.navigationTitle, "owner/repo")
    }
}

class ViewController: NSViewController {
    override func loadView() {
        view = NSView()
    }
}
#endif
