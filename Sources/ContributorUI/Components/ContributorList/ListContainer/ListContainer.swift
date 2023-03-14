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
    associatedtype Collection: RandomAccessCollection where Collection.Element: Identifiable & Equatable

    var collection: Collection { get set }
    var state: ListContainerState { get set }

    var container: Container { get }
    func cell(_ element: Collection.Element) -> Cell
    func placeholder() -> Placeholder
}

enum ListContainerState {
    case idle
    case loading
    case end
}
