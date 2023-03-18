//
//  NSContributorCard.swift
//  
//
//  Created by Dscyre Scotti on 18/03/2023.
//

#if canImport(Cocoa)
import SwiftUI

public class NSContributorCard: NSView {
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
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.layer?.backgroundColor = .clear

        let card = ContributorCard(owner: configuration.owner, repo: configuration.repo)
            .configure(with: configuration)
            .fixedSize(horizontal: false, vertical: true)
            .onChangeSize { [weak self] size in
                self?.updateHeightConstraint(size)
            }
        let hostingView = NSHostingView(rootView: card)
        hostingView.wantsLayer = true
        hostingView.layer?.masksToBounds = false
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: self.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
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
