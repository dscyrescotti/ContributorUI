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
            return .emptyError
        case 1:
            return .invalidURL
        case 2:
            return .unknownError
        case 3:
            return .notFoundError
        case 4:
            return .forbiddenError
        default:
            return nil
        }
    }
}
