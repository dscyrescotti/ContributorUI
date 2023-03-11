//
//  Contributor.swift
//  
//
//  Created by Aye Chan on 3/8/23.
//

import Foundation

typealias Contributors = Array<Contributor>

struct Contributor: Decodable, Identifiable, Equatable {
    let id: Int
    let type: String
    let login: String
    let nodeId: String
    let htmlURL: String
    let siteAdmin: Bool
    let avatarURL: String
    let contributions: Int

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case login
        case contributions
        case nodeId = "node_id"
        case htmlURL = "html_url"
        case siteAdmin = "site_admin"
        case avatarURL = "avatar_url"
    }
    
    func imageURL(with scale: CGFloat) -> URL? {
        let scale = Int(ceil(scale))
        return URL(string: avatarURL + "&s=\(scale)")
    }
}
