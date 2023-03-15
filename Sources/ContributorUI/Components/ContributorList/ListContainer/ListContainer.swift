//
//  ListContainer.swift
//  
//
//  Created by Aye Chan on 3/13/23.
//

import SwiftUI
import Foundation

protocol ListContainer {
    associatedtype Container: View
    associatedtype Cell: View
    associatedtype Placeholder: View

    var contributors: Contributors { get set }
    var state: ListContainerState { get set }
    var configutation: ContributorList.Configuration { get set }

    var container: Container { get }
    func cell(_ contributor: Contributor) -> Cell
    func placeholder() -> Placeholder
}

enum ListContainerState {
    case idle
    case loading
    case end
}
