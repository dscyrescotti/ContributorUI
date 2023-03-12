//
//  APIError.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import Foundation

enum APIError: Error {
    case emptyError
    case invalidURL
    case unknownError
    case notFoundError
    case forbiddenError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyError: return "Nothing Existed"
        case .invalidURL: return "Invalid URL"
        case .unknownError: return "Something Went Wrong"
        case .notFoundError: return "Nothing Found"
        case .forbiddenError: return "Access Denied"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .emptyError: return "There is no resource or data existed on the repository. Please provide a valid repository."
        case .invalidURL: return "The URL is not valid to perform network request."
        case .unknownError: return "Something did not work out as expected. Please try again."
        case .notFoundError: return "There is no repository that you requested. Please provide a valid repository."
        case .forbiddenError: return "You do not have an authorized access to the repository. Please provide a valid repository."
        }
    }
}
