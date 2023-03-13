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
        var listAppearance: ListAppearance

        init(
            repo: String,
            owner: String,
            listAppearance: ListAppearance = .table
        ) {
            self.repo = repo
            self.owner = owner
            self.listAppearance = listAppearance
        }
    }
}
