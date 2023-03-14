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

    var body: some View {
        container
    }

    var container: some View {
        List {
            ForEach(collection) { element in
                cell(element)
            }
        }
        .listStyle(.plain)
    }

    func cell(_ element: Collection.Element) -> some View {
        HStack {
            KFImage(contributor.imageURL)
                .placeholder {
                    Rectangle()
                        .foregroundColor(.secondary)
                }
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 5) {
                Text(element.login)
                    .font(.headline)
                Text("\(element.contributions) commits")
                    .font(.caption)
            }
        }
    }
}
