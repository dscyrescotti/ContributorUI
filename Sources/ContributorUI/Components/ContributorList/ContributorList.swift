//
//  ContributorList.swift
//  
//
//  Created by Aye Chan on 3/13/23.
//

import SwiftUI

public struct ContributorList: View {
    let configuration: Configuration

    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ContributorListViewModel

    #if canImport(XCTest)
    internal let inspection = Inspection<Self>()
    #endif

    init(configuration: Configuration, viewModel: StateObject<ContributorListViewModel>) {
        self.configuration = configuration
        self._viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(configuration.navigationTitle)
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                    if !configuration.hidesRepoLink {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Link(destination: URL(string: "https://github.com/\(configuration.owner)/\(configuration.repo)")!) {
                                Image("github", bundle: .contribtorUI)
                            }
                            .tint(.primary)
                        }
                    }
                })
                #else
                .toolbar(content: {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Close") {
                            dismiss()
                        }
                        .onHover { isHovered in
                            DispatchQueue.main.async {
                                if (isHovered) {
                                    NSCursor.pointingHand.push()
                                } else {
                                    NSCursor.pop()
                                }
                            }
                        }
                    }
                    if !configuration.hidesRepoLink {
                        ToolbarItem(placement: .primaryAction) {
                            Link(destination: URL(string: "https://github.com/\(configuration.owner)/\(configuration.repo)")!) {
                                Image("github", bundle: .contribtorUI)
                                    .foregroundColor(.primary)
                            }
                            .help("Visit the repository on GitHub")
                            .onHover { isHovered in
                                DispatchQueue.main.async {
                                    if (isHovered) {
                                        NSCursor.pointingHand.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                            }
                        }
                    }
                })
                #endif
        }
        .task {
            await viewModel.loadContributors(with: configuration)
        }
        #if canImport(XCTest)
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
        #endif
    }

    @ViewBuilder
    var contentView: some View {
        if viewModel.contributors.isEmpty, let error = viewModel.error {
            ErrorPrompt(error: error) {
                await viewModel.loadContributors(with: configuration)
            }
            .padding(20)
        } else {
            container
        }
    }

    @ViewBuilder
    var container: some View {
        switch configuration.listStyle {
        case .table:
            TableListContainer(
                contributors: viewModel.contributors,
                state: viewModel.state,
                configutation: configuration,
                loadNextPage: viewModel.loadNextPageIfReachToBottom
            )
        case .grid:
            GridListContainer(
                contributors: viewModel.contributors,
                state: viewModel.state,
                configutation: configuration,
                loadNextPage: viewModel.loadNextPageIfReachToBottom
            )
        }
    }
}

extension ContributorList {
    public init(owner: String, repo: String) {
        self.configuration = Configuration(repo: repo, owner: owner)
        let viewModel = ContributorListViewModel(github: .live)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    #if canImport(XCTest)
    init(owner: String, repo: String, github: GitHub) {
        self.configuration = Configuration(repo: repo, owner: owner)
        let viewModel = ContributorListViewModel(github: github)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    #endif
}

public extension ContributorList {
    func showsCommits(_ value: Bool) -> ContributorList {
        var configuration = self.configuration
        configuration.showsCommits = value
        return ContributorList(configuration: configuration, viewModel: self._viewModel)
    }

    func hidesRepoLink(_ value: Bool) -> ContributorList {
        var configuration = self.configuration
        configuration.hidesRepoLink = value
        return ContributorList(configuration: configuration, viewModel: self._viewModel)
    }

    func avatarStyle(_ style: AvatarStyle) -> ContributorList {
        var configuration = self.configuration
        configuration.avatarStyle = style
        return ContributorList(configuration: configuration, viewModel: self._viewModel)
    }

    func contributorListStyle(_ style: ContributorListStyle) -> ContributorList {
        var configuration = self.configuration
        configuration.listStyle = style
        return ContributorList(configuration: configuration, viewModel: self._viewModel)
    }

    func navigationTitle(_ title: String) -> ContributorList {
        var configuration = self.configuration
        configuration.title = title
        return ContributorList(configuration: configuration, viewModel: self._viewModel)
    }
}

extension ContributorList {
    func configure(with configuration: Configuration) -> ContributorList {
        ContributorList(configuration: configuration, viewModel: self._viewModel)
    }
}
