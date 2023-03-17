//
//  TestContributroListViewModel.swift
//  
//
//  Created by Aye Chan on 3/16/23.
//

import Foundation
@testable import ContributorUI

class TestContributroListViewModel: ContributorListViewModel {
    override func loadContributors(with configuration: ContributorList.Configuration) async {
        await MainActor.run {
            self.error = nil
            self.state = .loading
        }
    }
}
