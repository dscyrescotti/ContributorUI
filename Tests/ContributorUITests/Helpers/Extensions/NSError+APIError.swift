//
//  NSError+APIError.swift
//  
//
//  Created by Dscyre Scotti on 12/03/2023.
//

import Foundation
@testable import ContributorUI

extension NSError {
    func apiError() -> APIError? {
        switch code {
        case 0:
            return .invalidURL
        default:
            return nil
        }
    }
}
