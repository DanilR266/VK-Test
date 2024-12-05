//
//  MainWorker.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation

enum RequestURL: String {
    case git = "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page="
}

class MainWorker {
    func fetchRepositories(page: Int) async throws -> [Item] {
        let url = URL(string: "\(RequestURL.git.rawValue)\(page)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(Repository.self, from: data)
            print(response, "response")
            return response.items
        } catch {
            print("Error fetching repositories: \(error)")
            return []
        }
    }
    
    func loadImage(by url: String) async throws -> Data? {
        let url = URL(string: url)!
        do {
            let data = try await URLSession.shared.data(from: url)
            return data.0
        }
        catch {
            return nil
        }
    }
}
