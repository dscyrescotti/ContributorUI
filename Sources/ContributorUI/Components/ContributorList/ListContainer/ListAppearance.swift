//
//  ListAppearance.swift
//  
//
//  Created by Aye Chan on 3/13/23.
//

import SwiftUI
import Foundation

public enum ListAppearance {
    case table
    case grid
}

extension ListAppearance {
    @ViewBuilder
    func container(with contributors: Contributors) -> some View {
        switch self {
        case .table:
            TableListContainer(collection: contributors)
        case .grid:
            EmptyView()
        }
    }
}
