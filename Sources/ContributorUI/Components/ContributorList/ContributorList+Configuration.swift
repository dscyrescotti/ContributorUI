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
        public var title: String?
        public var showsCommits: Bool
        public var hidesRepoLink: Bool
        public var avatarStyle: AvatarStyle
        public var listStyle: ContributorListStyle

        init(
            repo: String,
            owner: String,
            title: String? = nil,
            showsCommits: Bool = false,
            hidesRepoLink: Bool = false,
            avatarStyle: AvatarStyle = .circle,
            listStyle: ContributorListStyle = .table
        ) {
            self.repo = repo
            self.owner = owner
            self.title = title
            self.listStyle = listStyle
            self.avatarStyle = avatarStyle
            self.showsCommits = showsCommits
            self.hidesRepoLink = hidesRepoLink
        }

        var navigationTitle: String {
            title ?? owner + "/" + repo
        }
    }
}
