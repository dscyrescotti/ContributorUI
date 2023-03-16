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

    var page: Int = 1
    var lastId: Int?

    init(github: GitHub) {
        self.github = github
    }

    func loadContributors(with configuration: ContributorList.Configuration) async {
        do {
            guard self.state == .idle else { return }
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
                parameters: [
                    "per_page":"50",
                    "page":"\(page)"
                ]
            )
            self.page += 1
            self.lastId = contributors.last?.id
            await MainActor.run {
                self.contributors.append(contentsOf: contributors)
                self.state = contributors.count < 50 ? .end : .idle
            }
        } catch {
            await MainActor.run {
                self.error = error as? APIError ?? .unknownError
                self.state = .idle
            }
        }
    }

    func loadNextPageIfReachToBottom(_ contributor: Contributor, with configuration: ContributorList.Configuration) async {
        guard contributor.id == lastId else { return }
        await loadContributors(with: configuration)
    }
}
