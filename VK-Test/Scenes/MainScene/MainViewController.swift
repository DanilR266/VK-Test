//
//  MainViewController.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import UIKit
import Combine

final class MainViewController: UIViewController {

    var router: MainRouting?
    var interactor: MainInteractor?
    
    private var cancellables: Set<AnyCancellable> = []
    
    var dataRepositories = [Item]()
    var allDataRepositories = [Item]()
    var dataImages = [Int: Data]()
    private var page: Int = 1
    private var errorPage = false
    
    private let tableView = UITableView()
    private let size = Size.shared
    
    let mainView = MainView()
    
    var stackHeight: NSLayoutConstraint!
    
    var buttonNameSortActive = false
    var buttonLanguageSortActive = false
    var buttonRepoSortActive = false
    var stackShow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        getCurrentPage()
        setupStackHeight()
        setupTableView()
        fetchRepositories()
        buttonsActions()
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    private func getCurrentPage() {
        page = interactor?.getLastPageNumber() ?? 1
    }

    func fetchRepositories() {
        setActivityIndicator()
        guard let interactor = interactor else { return }
        interactor.bindToPresenter(page: page)
    }
    
    func updateData(items: [Item], empty: Bool) {
        if !empty {
            errorPage = false
        }
        removeActivityIndicator()
        dataRepositories = items
        allDataRepositories = items
        tableView.reloadData()
    }
    
    func updateSortedData(items: [Item]) {
        dataRepositories = items
        tableView.reloadData()
    }
    
    func updateName(items: [Item]) {
        dataRepositories = items
        allDataRepositories = items
        tableView.reloadData()
    }
    
    func updateLoadImage(data: Data?, index: Int) {
        if let data = data {
            DispatchQueue.main.async {
                self.dataImages[index] = data
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = self.tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                    cell.iconCell.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func setupStackHeight() {
        stackHeight = mainView.stackView.heightAnchor.constraint(equalToConstant: size.height(0))
        NSLayoutConstraint.activate([ stackHeight ])
    }
    
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = size.height(132)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainView.stackView.bottomAnchor, constant: size.height(15)),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: size.width(21)),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -size.width(21))
        ])
    }
    
    private func buttonsActions() {
        mainView.buttonSortVoid = {
            self.stackShow.toggle()
            UIView.animate(withDuration: 0.2) {
                self.stackHeight.constant = self.stackShow ? self.size.height(36) : 0
                self.view.layoutIfNeeded()
            }
            self.inactiveAllButtonsSort()
            self.interactor?.sortedData(repositories: self.allDataRepositories, by: "none")
        }
        
        mainView.buttonSortNameVoid = {
            self.inactiveAllButtonsSort()
            self.buttonNameSortActive = true
            self.interactor?.sortedData(repositories: self.allDataRepositories, by: "name")
        }
        
        mainView.buttonSortLanguageVoid = {
            self.inactiveAllButtonsSort()
            self.buttonLanguageSortActive = true
            self.interactor?.sortedData(repositories: self.allDataRepositories, by: "language")
        }
        
        mainView.buttonSortRepoVoid = {
            self.inactiveAllButtonsSort()
            self.buttonRepoSortActive = true
            self.interactor?.sortedData(repositories: self.allDataRepositories, by: "repo")
        }
    }
    
    private func inactiveAllButtonsSort() {
        self.buttonNameSortActive = false
        self.buttonLanguageSortActive = false
        self.buttonRepoSortActive = false
    }
    
    private func setActivityIndicator() {
        mainView.activityIndicator.startAnimating()
        view.layoutIfNeeded()
    }
    
    private func removeActivityIndicator() {
        mainView.activityIndicator.stopAnimating()
        view.layoutIfNeeded()
    }
    
    private func showEditAlert(for item: Item) {
        let alertController = UIAlertController(title: ConstantsString.editName, message: ConstantsString.setName, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = ConstantsString.newName
        }

        let okAction = UIAlertAction(title: ConstantsString.ok, style: .default) { [weak self, weak alertController] _ in
            guard let self = self else { return }
            guard let textField = alertController?.textFields?.first,
                  let newName = textField.text,
                  !newName.isEmpty else {
                print("Name cannot be empty")
                return
            }
            interactor?.setNewName(id: item.id, name: newName)
        }

        let cancelAction = UIAlertAction(title: ConstantsString.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let item = dataRepositories[indexPath.row]
        if let savedImage = dataRepositories[indexPath.row].imageData {
            cell.iconCell.image = UIImage(data: savedImage)
        }
        else {
            if let data = dataImages[indexPath.row] {
                cell.iconCell.image = UIImage(data: data)
            }
            else {
                cell.iconCell.image = nil
                interactor?.bindForLoadImage(by: item.owner.avatarURL, index: indexPath.row, id: item.id)
            }
        }
        cell.goToGit = { [weak self] in
            guard let self = self, let url = URL(string: item.htmlURL) else { return }
            self.router?.openURL(url)
        }
        cell.configureCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataRepositories.count - 1 && !errorPage {
            errorPage = true
            page += 1
            setActivityIndicator()
            fetchRepositories()
            interactor?.setLastPageNumber(page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataRepositories[indexPath.row]
        showEditAlert(for: item)
    }
}

