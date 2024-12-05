//
//  MainInteractor.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import Combine

class MainInteractor {
    var worker: MainWorker?
    var presenter: MainPresenter?
    var realm = RealmManager.shared
    private var cancellables: Set<AnyCancellable> = []

    func fetchRepositories(page: Int) -> AnyPublisher<[Item], Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success([]))
                return
            }
            Task {
                do {
                    let repositories = try await self.worker?.fetchRepositories(page: page)
                    promise(.success(repositories ?? []))
                } catch {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchImageData(by url: String, index: Int) -> AnyPublisher<(Data?, Int), Error> {
        Future { [weak self] promise in
            Task {
                do {
                    let imageData = try await self?.worker?.loadImage(by: url)
                    promise(.success((imageData ?? nil, index)))
                } catch {
                    promise(.success((nil, -1)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func bindToPresenter(page: Int) {
        self.fetchRepositories(page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] repositories in
                if repositories.isEmpty {
                    let repo = self?.realm.fetchRepositories()
                    let decodeRepo = repo?.map { object in
                        Item(id: object.id,
                             name: object.repoName,
                             owner: Owner(login: object.name, id: 0, avatarURL: object.ownerAvatarURL),
                             htmlURL: object.htmlURL,
                             language: object.languageName,
                             visibility: object.visName,
                             forksCount: object.forksCount,
                             imageData: object.imageData)
                    }
                    self?.presenter?.fetchRepositories(repositories: decodeRepo ?? [], empty: true)
                }
                else {
                    let repositoryObjects = repositories.map { RepositoryObject(item: $0) }
                    self?.realm.saveRepositories(repositoryObjects) { repositories in
                        let decodeRepo = repositories.map { object in
                            Item(id: object.id,
                                 name: object.repoName,
                                 owner: Owner(login: object.name, id: 0, avatarURL: object.ownerAvatarURL),
                                 htmlURL: object.htmlURL,
                                 language: object.languageName,
                                 visibility: object.visName,
                                 forksCount: object.forksCount,
                                 imageData: object.imageData)
                        }
                        self?.presenter?.fetchRepositories(repositories: decodeRepo, empty: false)
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    private func setImageData(id: Int, data: Data) {
        realm.updateRepositoryImageData(by: id, data: data)
    }
    
    func setNewName(id: Int, name: String) {
        realm.setNewName(by: id, name: name) {
            let repo = self.realm.fetchRepositories()
            let decodeRepo = repo.map { object in
                Item(id: object.id,
                     name: object.repoName,
                     owner: Owner(login: object.name, id: 0, avatarURL: object.ownerAvatarURL),
                     htmlURL: object.htmlURL,
                     language: object.languageName,
                     visibility: object.visName,
                     forksCount: object.forksCount,
                     imageData: object.imageData)
            }
            self.presenter?.updateName(repositories: decodeRepo)
        }
    }
    
    func bindForLoadImage(by url: String, index: Int, id: Int) {
        self.fetchImageData(by: url, index: index)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] data in
                if let imageData = data.0 {
                    self?.setImageData(id: id, data: imageData)
                    self?.presenter?.loadImage(data: imageData, index: data.1)
                }
            })
            .store(in: &cancellables)
    }
    
    
    func sortedData(repositories: [Item], by key: String) {
        switch key {
        case "name":
            presenter?.sortedData(repositories: repositories.sorted(by: {$0.owner.login < $1.owner.login}))
        case "language":
            presenter?.sortedData(repositories: repositories.sorted(by: {$0.language ?? "" < $1.language ?? ""}))
        case "repo":
            presenter?.sortedData(repositories: repositories.sorted(by: {$0.name < $1.name}))
        default:
            presenter?.sortedData(repositories: repositories)
        }
    }
    
    func setLastPageNumber(_ page: Int) {
        UserDefaults.standard.set(page, forKey: "page")
    }
    
    func getLastPageNumber() -> Int {
        if let value = UserDefaults.standard.value(forKey: "page") as? Int {
            return value
        }
        return 1
    }
}
