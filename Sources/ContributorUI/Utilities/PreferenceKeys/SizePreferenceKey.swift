//
//  File.swift
//  
//
//  Created by Aye Chan on 3/11/23.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}
