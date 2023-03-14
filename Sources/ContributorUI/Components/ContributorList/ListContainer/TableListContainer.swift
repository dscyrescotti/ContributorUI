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
    typealias Collection = Contributors

    var collection: Collection
    var state: ListContainerState

    @ScaledMetric var size: CGFloat = 50

    var body: some View {
        container
    }

    var container: some View {
        List {
            ForEach(collection) { element in
                cell(element)
            }
            switch state {
            case .idle:
                EmptyView()
            case .loading:
                if collection.isEmpty {
                    ForEach(0..<4, id: \.self) { index in
                        placeholder()
                    }
                } else {
                    placeholder()
                }
            case .end:
                EmptyView()
            }
        }
        .listStyle(.plain)
    }

    func cell(_ element: Collection.Element) -> some View {
        HStack(spacing: 10) {
            KFImage(element.imageURL)
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.4))
                }
                .resizable()
                .diskCacheExpiration(.days(1))
                .frame(width: size, height: size)
            VStack(alignment: .leading, spacing: 5) {
                Text(element.login)
                    .font(.headline)
                Text("\(element.contributions) commits")
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
