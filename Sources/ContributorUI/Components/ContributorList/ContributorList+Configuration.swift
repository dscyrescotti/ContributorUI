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
        var includesAnonymous: Bool
        var avatarStyle: AvatarStyle
        var listAppearance: ContributorListStyle

        init(
            repo: String,
            owner: String,
            includesAnonymous: Bool = false,
            avatarStyle: AvatarStyle = .circle,
            listAppearance: ContributorListStyle = .table
        ) {
            self.repo = repo
            self.owner = owner
            self.avatarStyle = avatarStyle
            self.listAppearance = listAppearance
            self.includesAnonymous = includesAnonymous
        }
    }
}
