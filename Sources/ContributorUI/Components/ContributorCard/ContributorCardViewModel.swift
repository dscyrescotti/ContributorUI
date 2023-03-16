//
//  ContributorCardViewModel.swift
//  
//
//  Created by Aye Chan on 3/9/23.
//

import Foundation

class ContributorCardViewModel: ObservableObject {
    let github: GitHub

    @Published var error: APIError?
    @Published var isLoading: Bool = false
    @Published var contributors: Contributors = []

    init(github: GitHub) {
        self.github = github
    }

    func loadContributors(with configuration: ContributorCard.Configuration) async {
        do {
            await MainActor.run {
                self.error = nil
                self.isLoading = true
            }
            let contributors = try await github.fetch(
                Contributors.self,
                from: .listRepositoryContributors(
                    owner: configuration.owner,
                    repo: configuration.repo
                ),
                parameters: [
                    "per_page":"\(configuration.maximumDisplayCount)"
                ]
            )
            await MainActor.run {
                self.isLoading = false
                self.contributors = contributors
            }
        } catch {
            await MainActor.run {
                self.error = error as? APIError ?? .unknownError
                self.isLoading = false
            }
        }
    }
}
