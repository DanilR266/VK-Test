//
//  RealmManagerTests.swift
//  VK-TestTests
//
//  Created by Данила on 05.12.2024.
//

import XCTest
import RealmSwift
@testable import VK_Test

final class RealmManagerTests: XCTestCase {
    
    var realmManager: RealmManager!
    var testRealm: Realm!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "TestRealm"
        Realm.Configuration.defaultConfiguration = config
        
        testRealm = try Realm()
        realmManager = RealmManager()
    }
    
    override func tearDownWithError() throws {
        testRealm.invalidate()
        try super.tearDownWithError()
    }
    
    func testFetchRepositories_Empty() {
        let repositories = realmManager.fetchRepositories()
        XCTAssertEqual(repositories.count, 0, "Fetched repositories should be empty.")
    }
    
    func testSaveAndFetchRepositories() throws {
        let repo1 = RepositoryObject()
        repo1.id = 1
        repo1.repoName = "TestRepo1"
        
        let repo2 = RepositoryObject()
        repo2.id = 2
        repo2.repoName = "TestRepo2"
        
        realmManager.saveRepositories([repo1, repo2]) { savedRepositories in
            XCTAssertEqual(savedRepositories.count, 2, "Two repositories should be saved.")
        }
        
        let fetchedRepositories = realmManager.fetchRepositories()
        XCTAssertEqual(fetchedRepositories.count, 2, "Fetched repositories count should match saved count.")
    }
    
    func testUpdateRepositoryImageData() throws {
        let repo = RepositoryObject()
        repo.id = 1
        realmManager.saveRepositories([repo]) { _ in }
        XCTAssertNil(repo.imageData)
        let testData = Data([0x00, 0x01, 0x02])
        realmManager.updateRepositoryImageData(by: 1, data: testData)
        
        let updatedRepo = realmManager.fetchRepositories().first(where: { $0.id == 1 })
        XCTAssertEqual(updatedRepo?.imageData, testData, "Image data should match the updated value.")
    }
    
    func testSetNewName() throws {
        let repo = RepositoryObject()
        repo.id = 1
        
        realmManager.saveRepositories([repo]) { _ in }
        
        let expectation = XCTestExpectation(description: "Completion handler called")
        realmManager.setNewName(by: 1, name: "NewName") {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        let updatedRepo = realmManager.fetchRepositories().first(where: { $0.id == 1 })
        XCTAssertEqual(updatedRepo?.repoName, "NewName", "Repository name should be updated.")
    }
}
