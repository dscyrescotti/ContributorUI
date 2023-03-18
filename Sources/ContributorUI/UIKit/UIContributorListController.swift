//
//  UIContributorListController.swift
//  
//
//  Created by Aye Chan on 3/18/23.
//

#if canImport(UIKit)
import SwiftUI

public class UIContributorListController: UIViewController {
    let configuration: ContributorList.Configuration

    public init(owner: String, repo: String, configure: @escaping (inout ContributorList.Configuration) -> Void) {
        var configuration = ContributorList.Configuration(repo: repo, owner: owner)
        configure(&configuration)
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let list = ContributorList(owner: configuration.owner, repo: configuration.repo)
            .configure(with: configuration)
        let hostingController = UIHostingController(rootView: list)

        let view = hostingController.view!
        view.translatesAutoresizingMaskIntoConstraints = false

        addChild(hostingController)
        self.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}
#endif
