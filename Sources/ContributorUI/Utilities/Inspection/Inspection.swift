//
//  Inspection.swift
//  
//
//  Created by Aye Chan on 3/12/23.
//

#if canImport(XCTest)
import Combine
import SwiftUI

internal final class Inspection<V> {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()

    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
#endif
