//
//  Repository.swift
//  Demo
//
//  Created by Aye Chan on 3/19/23.
//

import Foundation

struct Repository: Identifiable, Hashable, Codable {
    var id: String { title }
    let owner: String
    let repo: String

    var title: String {
        owner + "/" + repo
    }
}

extension Repository {
    static let swift = Repository(owner: "apple", repo: "swift")
    static let charts = Repository(owner: "danielgindi", repo: "Charts")
    static let copilotForXcode = Repository(owner: "intitni", repo: "CopilotForXcode")
    static let vapor = Repository(owner: "vapor", repo: "vapor")
    static let asyncAlgorithm = Repository(owner: "apple", repo: "swift-async-algorithms")
    static let swiftTheming = Repository(owner: "dscyrescotti", repo: "SwiftTheming")
    static let alamofire = Repository(owner: "Alamofire", repo: "Alamofire")
    static let composableArchitecture = Repository(owner: "pointfreeco", repo: "swift-composable-architecture")
    static let roadMap = Repository(owner: "AvdLee", repo: "Roadmap")
    static let shuffleIt = Repository(owner: "dscyrescotti", repo: "ShuffleIt")
    static let realm = Repository(owner: "realm", repo: "realm-swift")
}

extension Array where Element == Repository {
    static let all: Self = [.swift, .charts, .copilotForXcode, .vapor, .asyncAlgorithm, .swiftTheming, .alamofire, .composableArchitecture, .roadMap, .shuffleIt, .realm]
}
