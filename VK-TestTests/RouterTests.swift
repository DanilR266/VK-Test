//
//  RouterTests.swift
//  VK-TestTests
//
//  Created by Данила on 05.12.2024.
//

import XCTest
@testable import VK_Test

class MockApplication: UIApplicationProtocol {
    var canOpenURLCalled = false
    var openURLCalled = false
    var lastURL: URL?

    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLCalled = true
        lastURL = url
        return true
    }

    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler: ((Bool) -> Void)?) {
        openURLCalled = true
        lastURL = url
        completionHandler?(true)
    }
}


final class MainRouterTests: XCTestCase {

    func testOpenURL() {
        
        let mockApplication = MockApplication()
        let router = MainRouter(application: mockApplication)
        let testURL = URL(string: "https://google.com")!

        router.openURL(testURL)

        XCTAssertTrue(mockApplication.canOpenURLCalled, "canOpenURL should be called")
        XCTAssertTrue(mockApplication.openURLCalled, "open should be called")
        XCTAssertEqual(mockApplication.lastURL, testURL, "The URL passed to open should match the test URL")
    }
}
