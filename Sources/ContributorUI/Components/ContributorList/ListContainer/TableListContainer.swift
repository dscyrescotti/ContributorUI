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
            ForEach(contributors) { element in
                cell(element)
                    .task {
                        await loadNextPage(element, configutation)
                    }
            }
            switch state {
            case .loading:
                let count = contributors.isEmpty ? 4 : 3
                ForEach(0..<count, id: \.self) { index in
                    placeholder()
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
                Text("\(contributor.contributions) commits")
                    .font(.caption)
            }
        }
    }

    func placeholder() -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .foregroundColor(.gray.opacity(0.4))
                .frame(width: size, height: size)
                .shimmering()
                .clipShape(configutation.avatarStyle.shape())
                .fixedSize()
            VStack(alignment: .leading, spacing: 5) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(width: 150, height: size * 0.3)
                    .shimmering()
                Rectangle()
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(width: 60, height: size * 0.2)
                    .shimmering()
                    .fixedSize()
            }
            .fixedSize()
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            return viewDimensions[.listRowSeparatorLeading] + size + 10
        }
    }
}
