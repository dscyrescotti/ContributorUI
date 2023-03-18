//
//  UIContributorCard.swift
//  
//
//  Created by Aye Chan on 3/17/23.
//

#if canImport(UIKit)
import SwiftUI

public class UIContributorCard: UIView {
    let configuration: ContributorCard.Configuration
    var heightConstraint: NSLayoutConstraint?

    public init(owner: String, repo: String, configure: @escaping (inout ContributorCard.Configuration) -> Void) {
        var configuration = ContributorCard.Configuration(repo: repo, owner: owner)
        configure(&configuration)
        self.configuration = configuration
        super.init(frame: .zero)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
        self.backgroundColor = .clear

        let card = ContributorCard(owner: configuration.owner, repo: configuration.repo)
            .configure(with: configuration)
            .fixedSize(horizontal: false, vertical: true)
            .onChangeSize { [weak self] size in
                self?.updateHeightConstraint(size)
            }
        let hostingController = UIHostingController(rootView: card)
        let view = hostingController.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    func updateHeightConstraint(_ size: CGSize) {
        if let heightConstraint {
            self.removeConstraint(heightConstraint)
            self.heightConstraint = nil
        }
        heightConstraint = self.heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint?.isActive = true
    }
}
#endif
