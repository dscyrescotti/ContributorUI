//
//  API.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import Foundation

protocol API {
    associatedtype Endpoints: Endpoint

    var baseURL: URL? { get }
    var headers: [String: String] { get }
    
    func urlRequest(_ endpoint: Endpoints, parameters: [String: String]) throws -> URLRequest
}

extension API {
    func urlRequest(_ endpoint: Endpoints, parameters: [String: String]) throws -> URLRequest {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url, timeoutInterval: 60)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
