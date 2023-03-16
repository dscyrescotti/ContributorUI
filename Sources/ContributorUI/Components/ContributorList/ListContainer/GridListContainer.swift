//
//  GridListContainer.swift
//  
//
//  Created by Aye Chan on 3/15/23.
//

import SwiftUI
import Foundation
import Kingfisher

struct GridListContainer: View, ListContainer {
    var contributors: Contributors
    var state: ListContainerState
    var configutation: ContributorList.Configuration
    var loadNextPage: (Contributor, ContributorList.Configuration) async -> Void

    @ScaledMetric var size: CGFloat = 110

    var body: some View {
        container
    }

    @ViewBuilder
    var container: some View {
        GeometryReader { geometry in
            let count = Int(geometry.size.width / size)
            let spacing: CGFloat = 10
            let columns = [GridItem](repeating: GridItem(.flexible(), spacing: spacing, alignment: .top), count: count)
            let size = (geometry.size.width - spacing * CGFloat(count + 1)) / CGFloat(count)
            let factor: CGFloat = configutation.showsCommits ? 1.1 : 0.9
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(contributors) { contributor in
                        cell(contributor)
                            .frame(width: size, height: size * factor)
                            .task {
                                await loadNextPage(contributor, configutation)
                            }
                    }
                    switch state {
                    case .loading:
                        let count = contributors.isEmpty ? 4 : 3
                        ForEach(0..<count, id: \.self) { index in
                            placeholder()
                                .frame(width: size, height: size * factor)
                        }
                    case .idle, .end:
                        EmptyView()
                    }
                }
                .padding(10)
            }
        }
    }

    func cell(_ contributor: Contributor) -> some View {
        GeometryReader { geometry in
            let size = geometry.size.width * 0.6
            VStack(spacing: 10) {
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
                VStack {
                    Text(contributor.login)
                        .font(.caption.bold())
                        .lineLimit(1)
                    if configutation.showsCommits {
                        Text("\(contributor.contributions) commits")
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(3)
    }

    func placeholder() -> some View {
        GeometryReader { geometry in
            let size = geometry.size.width * 0.6
            VStack(spacing: 10) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(width: size, height: size)
                    .shimmering()
                    .clipShape(configutation.avatarStyle.shape())
                    .fixedSize()
                VStack(spacing: 2) {
                    Capsule()
                        .foregroundColor(.gray.opacity(0.4))
                        .frame(width: 80, height: size * 0.11)
                        .shimmering()
                        .clipShape(Capsule())
                    if configutation.showsCommits {
                        Capsule()
                            .foregroundColor(.gray.opacity(0.4))
                            .frame(width: 60, height: size * 0.08)
                            .shimmering()
                            .clipShape(Capsule())
                    }
                }
                .fixedSize()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(3)
    }
}
