//
//  ViewController.swift
//  Demo-UIKit
//
//  Created by Aye Chan on 3/18/23.
//

import UIKit
import ContributorUI

class ViewController: UIViewController {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "apple/swift"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let button: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "See More"
        configuration.buttonSize = .small
        configuration.titlePadding = 0
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let card: UIContributorCard = {
        let view = UIContributorCard(owner: "apple", repo: "swift") { configuration in
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

        let clickAction = UIAction { [weak self] action in
            let vc = UIContributorListController(owner: "apple", repo: "swift") { configuration in
                configuration.listStyle = .grid
            }
            self?.present(vc, animated: true)
        }
        button.addAction(clickAction, for: .touchUpInside)
    }
}

