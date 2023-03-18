//
//  ViewController.swift
//  Demo-AppKit
//
//  Created by Dscyre Scotti on 18/03/2023.
//

import Cocoa
import ContributorUI

class ViewController: NSViewController {
    let titleLabel: NSTextField = {
        let label = NSTextField()
        label.stringValue = "apple/swift"
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let button: NSButton = {
        let button = NSButton()
        button.title = "See More"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let card: NSContributorCard = {
        let view = NSContributorCard(owner: "apple", repo: "swift") { configuration in
            configuration.padding = 15
            configuration.spacing = 15
            configuration.avatarStyle = .rectangle
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override var representedObject: Any? {
        didSet { }
    }
    
    func setUpUI() {
        view.addSubview(card)
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: card.topAnchor, constant: -15)
        ])
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: card.trailingAnchor)
        ])
        
        button.target = self
        button.action = #selector(onTapSeeMore)
    }
    
    @objc func onTapSeeMore() {
        let vc = NSContributorListController(owner: "apple", repo: "swift") { configuration in
            configuration.listStyle = .grid
        }
        vc.preferredContentSize = .init(width: 800, height: 300)
        presentAsModalWindow(vc)
    }
}
