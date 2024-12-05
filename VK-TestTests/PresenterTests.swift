//
//  PresenterTests.swift
//  VK-TestTests
//
//  Created by Данила on 05.12.2024.
//

import XCTest
@testable import VK_Test

final class PresenterTests: XCTestCase {

    var presenter: MainPresenter!
    var viewController: MainViewController!
    override func setUp() {
        super.setUp()
        presenter = MainPresenter()
        viewController = MainViewController()
        
        presenter.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
        presenter = nil
        super.tearDown()
    }
    
    func testFetchRepositories() {
        
        let items: [Item] = [
            Item(id: 2, name: "name2", owner: Owner(login: "owner2", id: 2, avatarURL: "2"), htmlURL: "2", language: "language2", visibility: "vis2", forksCount: 2, imageData: nil),
            Item(id: 1, name: "name1", owner: Owner(login: "owner1", id: 1, avatarURL: "1"), htmlURL: "1", language: "language1", visibility: "vis1", forksCount: 1, imageData: nil)
        ]
        presenter.fetchRepositories(repositories: items, empty: false)
        
        XCTAssertEqual(viewController.dataRepositories.count, items.count)
        
        presenter.fetchRepositories(repositories: [], empty: true)
        
        XCTAssertEqual(viewController.dataRepositories.count, 0)
    }

}
