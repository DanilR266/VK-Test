//
//  MainModels.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import RealmSwift

struct Repository: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Item: Codable {
    let id: Int
    let name: String
    let owner: Owner
    let htmlURL: String
    let language: String?
    let visibility: String
    let forksCount: Int
    let imageData: Data?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case htmlURL = "html_url"
        case language
        case forksCount = "forks_count"
        case visibility
        case imageData
    }
}

enum DefaultBranch: String, Codable {
    case master = "master"
    case main = "main"
}

struct Owner: Codable {
    let login: String
    let id: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}

enum Visibility: String, Codable {
    case visibilityPublic = "public"
    case visibilityPrivate = "private"
}

// Error request

struct ErrorRequest: Codable {
    let message: String
    let documentationURL: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case message
        case documentationURL = "documentation_url"
        case status
    }
}

// Realm model

class RepositoryObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var ownerAvatarURL: String
    @Persisted var repoName: String
    @Persisted var languageName: String?
    @Persisted var visName: String
    @Persisted var forksCount: Int
    @Persisted var htmlURL: String
    @Persisted var imageData: Data?
    
    convenience init(item: Item) {
        self.init()
        self.id = item.id
        self.name = item.owner.login
        self.ownerAvatarURL = item.owner.avatarURL
        self.repoName = item.name
        self.languageName = item.language
        self.visName = item.visibility
        self.forksCount = item.forksCount
        self.htmlURL = item.htmlURL
        self.imageData = item.imageData
    }
}


