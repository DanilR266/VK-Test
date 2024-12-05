//
//  MainRouter.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import UIKit

protocol MainRouting {
    func openURL(_ url: URL)
}

class MainRouter: MainRouting {
    weak var viewController: UIViewController?
    private let application: UIApplicationProtocol

    init(application: UIApplicationProtocol = UIApplication.shared) {
        self.application = application
    }

    func openURL(_ url: URL) {
        if application.canOpenURL(url) {
            application.open(url, options: [:], completionHandler: nil)
        }
    }
}

