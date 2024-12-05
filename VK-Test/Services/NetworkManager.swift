//
//  NetworkManager.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import SystemConfiguration
import UIKit
import Network


class NetworkManager {
    static let shared = NetworkManager()
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor
    var isNetworkAvailable: Bool = false

    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "connectivityStatusChanged"), object: nil)
        }
        monitor.start(queue: queue)
    }
    
}
