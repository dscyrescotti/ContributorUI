//
//  MockAPI.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import Foundation
@testable import ContributorUI

struct MockAPI: API {
    var baseURL: URL? = URL(string: "http://api.test.com/")
    var headers: [String : String] = ["Accept": "application/json"]

    enum Endpoints: Endpoint {
        case dummy

        var path: String {
            switch self {
            case .dummy: return "{dummy}"
            }
        }
    }
}
