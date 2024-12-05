//
//  MainPresenter.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import Combine

class MainPresenter {
    private var cancellables: Set<AnyCancellable> = []
    weak var viewController: MainViewController?

    func fetchRepositories(repositories: [Item], empty: Bool) {
        self.viewController?.updateData(items: repositories, empty: empty)
    }
    
    func sortedData(repositories: [Item]) {
        self.viewController?.updateSortedData(items: repositories)
    }
    
    func loadImage(data: Data?, index: Int) {
        guard let vc = viewController else { return }
        vc.updateLoadImage(data: data, index: index)
    }
    
    func updateName(repositories: [Item]) {
        self.viewController?.updateName(items: repositories)
    }
}
