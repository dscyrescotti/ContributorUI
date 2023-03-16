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
        var showsCommits: Bool
        var hidesRepoLink: Bool
        var avatarStyle: AvatarStyle
        var listAppearance: ContributorListStyle

        init(
            repo: String,
            owner: String,
            title: String? = nil,
            showsCommits: Bool = false,
            hidesRepoLink: Bool = false,
            avatarStyle: AvatarStyle = .circle,
            listAppearance: ContributorListStyle = .table
        ) {
            self.repo = repo
            self.owner = owner
            self.title = title
            self.avatarStyle = avatarStyle
            self.showsCommits = showsCommits
            self.hidesRepoLink = hidesRepoLink
            self.listAppearance = listAppearance
        }

        var navigationTitle: String {
            title ?? owner + "/" + repo
        }
    }
}
