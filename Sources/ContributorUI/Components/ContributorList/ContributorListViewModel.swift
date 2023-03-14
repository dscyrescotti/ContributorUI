//
//  ContributorListViewModel.swift
//  
//
//  Created by Aye Chan on 3/13/23.
//

import Foundation

class ContributorListViewModel: ObservableObject {
    let github: GitHub

    @Published var error: APIError?
    @Published var contributors: Contributors = []
    @Published var state: ListContainerState = .idle

    init(github: GitHub) {
        self.github = github
    }

    func loadContributors(with configuration: ContributorList.Configuration) async {
        do {
            await MainActor.run {
                self.error = nil
                self.state = .loading
            }
            let contributors = try await github.fetch(
                Contributors.self,
                from: .listRepositoryContributors(
                    owner: configuration.owner,
                    repo: configuration.repo
                ),
                parameters: [:]
            )
            await MainActor.run {
                self.state = contributors.isEmpty ? .end : .idle
                self.contributors = contributors
            }
        } catch {
            await MainActor.run {
                self.error = error as? APIError ?? .unknownError
                self.state = .idle
            }
        }
    }
}
