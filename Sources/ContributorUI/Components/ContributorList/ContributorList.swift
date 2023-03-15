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

    init(configuration: Configuration, viewModel: StateObject<ContributorListViewModel>) {
        self.configuration = configuration
        self._viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            container
                .navigationTitle("Contributors")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
        .task {
            await viewModel.loadContributors(with: configuration)
        }
    }

    @ViewBuilder
    var container: some View {
        switch configuration.listAppearance {
        case .table:
            TableListContainer(contributors: viewModel.contributors, state: viewModel.state, configutation: configuration)
        case .grid:
            EmptyView()
        }
    }
}

extension ContributorList {
    public init(owner: String, repo: String) {
        self.configuration = Configuration(repo: repo, owner: owner)
        let viewModel = ContributorListViewModel(github: .live)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
}
