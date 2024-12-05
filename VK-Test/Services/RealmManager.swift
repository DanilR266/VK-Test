//
//  RealmManager.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private let realm: Realm

    init() {
        self.realm = try! Realm()
    }

    func fetchRepositories() -> [RepositoryObject] {
        return Array(realm.objects(RepositoryObject.self))
    }

    func saveRepositories(_ repositories: [RepositoryObject], completion: @escaping ((([RepositoryObject]) -> Void))) {
        try? realm.write {
            for repository in repositories {
                if realm.object(ofType: RepositoryObject.self, forPrimaryKey: repository.id) == nil {
                    realm.add(repository)
                }
            }
            completion(self.fetchRepositories())
        }
    }
    
    func updateRepositoryImageData(by id: Int, data: Data) {
        if let repository = realm.object(ofType: RepositoryObject.self, forPrimaryKey: id) {
            try? realm.write {
                repository.imageData = data
            }
        } else {
            print("Object with ID \(id) not found in Realm.")
        }
    }
    
    func setNewName(by id: Int, name: String, completion: @escaping (() -> Void)) {
        if let repository = realm.object(ofType: RepositoryObject.self, forPrimaryKey: id) {
            try? realm.write {
                repository.repoName = name
                completion()
            }
        } else {
            print("Object with ID \(id) not found in Realm.")
        }
    }
}
