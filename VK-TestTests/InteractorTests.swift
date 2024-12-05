//
//  InteractorTests.swift
//  VK-TestTests
//
//  Created by Данила on 05.12.2024.
//

import XCTest
import Combine
@testable import VK_Test

class MockRealmManager: RealmManager {
    
    var savedItems: [Item] = []
    
    func save(items: [Item]) {
        savedItems.append(contentsOf: items)
    }
    
    func getSavedItems() -> [Item] {
        return savedItems
    }
    
    func deleteItem(byId id: Int) {
        savedItems.removeAll { $0.id == id }
    }
    
    func clearAllItems() {
        savedItems.removeAll()
    }
}

final class InteractorTests: XCTestCase {
    
    var interactor: MainInteractor!
    var presenter: MainPresenter!
    var viewController: MainViewController!
    var mockRealmManager: MockRealmManager!
    var cancellables: Set<AnyCancellable> = []
    override func setUp() {
        super.setUp()
        presenter = MainPresenter()
        mockRealmManager = MockRealmManager()
        viewController = MainViewController()
        interactor = MainInteractor()
        
        interactor.realm = mockRealmManager
        interactor.worker = MainWorker()
        interactor.presenter = presenter
        
        presenter.viewController = viewController
    }
    
    override func tearDown() {
        interactor = nil
        viewController = nil
        presenter = nil
        mockRealmManager = nil
        super.tearDown()
    }
    
    func testInteractorSorted() {
        let unsortedItems: [Item] = [
            Item(id: 2, name: "name2", owner: Owner(login: "owner2", id: 2, avatarURL: "2"), htmlURL: "2", language: "language2", visibility: "vis2", forksCount: 2, imageData: nil),
            Item(id: 1, name: "name1", owner: Owner(login: "owner1", id: 1, avatarURL: "1"), htmlURL: "1", language: "language1", visibility: "vis1", forksCount: 1, imageData: nil)
        ]
        interactor.sortedData(repositories: unsortedItems, by: "name")
        XCTAssertEqual(interactor.presenter?.viewController?.dataRepositories.first?.owner.login, "owner1")
    }
    
    func testInteractorFetchRepositories() async throws {
        do {
            let data = try await interactor.worker?.fetchRepositories(page: 1)
            XCTAssertTrue(data!.count > 0)
        }
        catch {
            XCTFail()
        }
    }
    
    func testInteractorSetName() async throws {
        do {
            let data = try await interactor.worker?.loadImage(by: "url")
            XCTAssertNil(data)
        }
        catch {
            XCTFail()
        }
    }
    
    func testInteractorCurrentPage() {
        interactor.setLastPageNumber(1)
        XCTAssert(interactor.getLastPageNumber() == 1)
    }
    
}
