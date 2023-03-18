//
//  UIContributorListController.swift
//  
//
//  Created by Aye Chan on 3/18/23.
//

#if canImport(UIKit)
import SwiftUI

public class UIContributorListController: UIHostingController<ContributorList> {
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
