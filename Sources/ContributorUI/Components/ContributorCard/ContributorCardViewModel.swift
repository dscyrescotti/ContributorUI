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

    @Published var isLoading: Bool = false
    @Published var contributors: Contributors = []

    init(dependency: Dependency) {
        self.repo = dependency.repo
        self.owner = dependency.owner
        self.github = dependency.github
    }

    func loadContributors(with configuration: ContributorCard.Configuration) async {
        do {
            await MainActor.run {
                self.isLoading = true
            }
            let contributors = try await github.fetch(
                Contributors.self,
                from: .listRepositoryContributors(
                    owner: owner,
                    repo: repo
                ),
                parameters: [
                    "anon":"\(configuration.includesAnonymous)",
                    "per_page":"\(configuration.maximumDisplayCount)"
                ]
            )
            await MainActor.run {
                self.isLoading = false
                self.contributors = contributors
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
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
