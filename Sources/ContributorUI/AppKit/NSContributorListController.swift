//
//  NSContributorListController.swift
//  
//
//  Created by Dscyre Scotti on 18/03/2023.
//

#if canImport(Cocoa)
import SwiftUI

public class NSContributorListController: NSHostingController<ContributorList> {
    public init(owner: String, repo: String, configure: @escaping (inout ContributorList.Configuration) -> Void) {
        var configuration = ContributorList.Configuration(repo: repo, owner: owner)
        configure(&configuration)
        let view = ContributorList(owner: configuration.owner, repo: configuration.repo)
            .configure(with: configuration)
        super.init(rootView: view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
