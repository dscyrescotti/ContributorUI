//
//  CardViewWrapper.swift
//  
//
//  Created by Aye Chan on 3/16/23.
//

import SwiftUI
import Foundation
@testable import ContributorUI

struct CardViewWrapper: View {
    let owner: String
    let repo: String
    let github: GitHub
    @State var displayCount = 30

    let inspection = Inspection<Self>()

    var body: some View {
        ContributorCard(owner: owner, repo: repo, github: github)
            .maximumDisplayCount(displayCount)
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
    }
}
