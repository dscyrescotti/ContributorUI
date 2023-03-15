//
//  ContributorList+Configuration.swift
//  
//
//  Created by Aye Chan on 3/13/23.
//

import Foundation

extension ContributorList {
    public struct Configuration {
        let repo: String
        let owner: String
        var title: String?
        var hidesRepoLink: Bool
        var includesAnonymous: Bool
        var avatarStyle: AvatarStyle
        var listAppearance: ContributorListStyle

        init(
            repo: String,
            owner: String,
            title: String? = nil,
            hidesRepoLink: Bool = false,
            includesAnonymous: Bool = false,
            avatarStyle: AvatarStyle = .circle,
            listAppearance: ContributorListStyle = .table
        ) {
            self.repo = repo
            self.owner = owner
            self.title = title
            self.avatarStyle = avatarStyle
            self.hidesRepoLink = hidesRepoLink
            self.listAppearance = listAppearance
            self.includesAnonymous = includesAnonymous
        }

        var navigationTitle: String {
            title ?? owner + "/" + repo
        }
    }
}
