//
//  UIApplication+Extension.swift
//  VK-Test
//
//  Created by Данила on 05.12.2024.
//

import Foundation
import UIKit

protocol UIApplicationProtocol {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler: ((Bool) -> Void)?)
}

extension UIApplication: UIApplicationProtocol {
    func open(_ url: URL, options: [OpenExternalURLOptionsKey : Any], completionHandler: ((Bool) -> Void)?) {
        
    }
}
