//
//  Networking.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import Foundation

class Networking<Interface: API> {
    let session: URLSession
    let decoder: JSONDecoder
    let interface: Interface

    init(
        on interface: Interface,
        session: URLSession = URLSession(configuration: .default),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.interface = interface
    }

    func fetch<T: Decodable>(_ type: T.Type, from endpoint: Interface.Endpoints, parameters: [String: String]) async throws -> T {
        let request = try interface.urlRequest(endpoint, parameters: parameters)
        let (data, _) = try await session.data(for: request)
        let result = try decoder.decode(T.self, from: data)
        return result
    }
}
