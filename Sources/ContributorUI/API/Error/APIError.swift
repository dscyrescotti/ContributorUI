//
//  APIError.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL: return "The URL is not valid to perform network request."
        }
    }
}
