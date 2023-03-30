//
//  TableListContainer.swift
//  
//
//  Created by Aye Chan on 3/13/23.
//

import SwiftUI
import Foundation
import Kingfisher

struct TableListContainer: View, ListContainer {
    var contributors: Contributors
    var state: ListContainerState
    var configutation: ContributorList.Configuration
    var loadNextPage: (Contributor, ContributorList.Configuration) async -> Void

    @ScaledMetric var size: CGFloat = 50

    var body: some View {
        container
    }

    var container: some View {
        List {
            ForEach(contributors) { contributor in
                cell(contributor)
                    .task {
                        await loadNextPage(contributor, configutation)
                    }
            }
            switch state {
            case .loading:
                VStack(alignment: .leading) {
                    let count = contributors.isEmpty ? 4 : 3
                    ForEach(0..<count, id: \.self) { index in
                        if index != 0 {
                            Divider()
                                .padding(.leading, size + 10)
                        }
                        placeholder()
                    }
                }
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    return viewDimensions[.listRowSeparatorLeading] + size + 10
                }
            case .idle, .end:
                EmptyView()
            }
        }
        .listStyle(.plain)
    }

    func cell(_ contributor: Contributor) -> some View {
        HStack(spacing: 10) {
            KFImage(contributor.imageURL)
                .startLoadingBeforeViewAppear()
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.4))
                }
                .resizable()
                .diskCacheExpiration(.days(1))
                .frame(width: size, height: size)
                .clipShape(configutation.avatarStyle.shape())
            VStack(alignment: .leading, spacing: 5) {
                Text(contributor.login)
                    .font(.headline)
                if configutation.showsCommits {
                    Text("\(contributor.contributions) commits")
                        .font(.caption)
                }
            }
        }
    }

    func placeholder() -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .foregroundColor(.gray.opacity(0.4))
                .shimmering()
                .frame(width: size, height: size)
                .clipShape(configutation.avatarStyle.shape())
                .fixedSize()
            VStack(alignment: .leading, spacing: 5) {
                Capsule()
                    .foregroundColor(.gray.opacity(0.4))
                    .shimmering()
                    .frame(width: 150, height: size * 0.3)
                    .clipShape(Capsule())
                if configutation.showsCommits {
                    Capsule()
                        .foregroundColor(.gray.opacity(0.4))
                        .shimmering()
                        .frame(width: 60, height: size * 0.2)
                        .fixedSize()
                        .clipShape(Capsule())
                }
            }
            .fixedSize()
        }
    }
}
