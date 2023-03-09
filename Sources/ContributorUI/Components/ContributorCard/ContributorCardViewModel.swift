//
//  ContributorCardViewModel.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import Foundation

class ContributorCardViewModel: ObservableObject {
    let repo: String
    let owner: String
    let github: GitHub

    @Published var contributors: Contributors = []

    init(dependency: Dependency) {
        self.repo = dependency.repo
        self.owner = dependency.owner
        self.github = dependency.github
    }

    func loadContributors() async {
        do {
            let contributors = try await github.fetch(Contributors.self, from: .listRepositoryContributors(owner: owner, repo: repo), parameters: ["per_page":"30"])
            await MainActor.run {
                self.contributors = contributors
            }
        } catch {
            print(error)
        }
    }
}

extension ContributorCardViewModel {
    struct Dependency {
        let repo: String
        let owner: String
        let github: GitHub
    }
}
