//
//  UIKitSupportTests.swift
//  
//
//  Created by Aye Chan on 3/18/23.
//

#if canImport(UIKit)
import XCTest
@testable import ContributorUI

class UIKitSupportTests: XCTestCase {
    func testUIContributorCard() throws {
        let card = UIContributorCard(owner: "owner", repo: "repo") { configuration in
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
        let vc = UIViewController()
        vc.view.addSubview(card)
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -20)
        ])
        let window = UIWindow(frame:  UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = vc
        XCTAssertEqual(vc.view.subviews.count, 1)
        XCTAssertEqual(vc.view.subviews[0], card)
    }

    func testUIContributorListController() throws {
        let vc = UIContributorListController(owner: "owner", repo: "repo") { configuration in
            configuration.avatarStyle = .rectangle
        }
        let window = UIWindow(frame:  UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = vc
        XCTAssertEqual(vc.view.subviews.count, 1)
        let configuration = vc.configuration
        XCTAssertNil(configuration.title)
        XCTAssertEqual(configuration.avatarStyle, .rectangle)
        XCTAssertEqual(configuration.listStyle, .table)
        XCTAssertFalse(configuration.showsCommits)
        XCTAssertFalse(configuration.hidesRepoLink)
        XCTAssertEqual(configuration.navigationTitle, "owner/repo")
    }
}
#endif
