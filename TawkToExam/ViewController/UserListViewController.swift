//
//  ViewController.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/18/21.
//

import UIKit

class UserListViewController: UIViewController {
    let tableView = UserTableView()
    let rowDataManager = UserRowCoreDataManager()
    let profileInfoDataManager = UserProfileInfoCoreDataManager()
    let noteDataManager = UserNoteCoreDataManager()
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupTableView()
        setupSearchController()
        noteDataManager.getAllDataAndStore { [weak self] noteDict in
            self?.tableView.viewModel.userNotesDictionary = noteDict
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleChangeInNetworkConnection(_:)), name: .networkConnectionChanged, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutIfNeeded()
    }
    
    @objc private func handleChangeInNetworkConnection(_ notification: Notification) {
        if let data = notification.object as? [String: Bool],
           let state = data["state"] {
            tableView.hasInternet = state
        }
    }
    
    private func setupViews() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        loadUserRowDataFromDisk { [weak self] userDataArray in
            DispatchQueue.main.async {
                if self?.tableView.viewModel.allUsers.isEmpty ?? false {
                    self?.tableView.viewModel.allUsers = userDataArray
                }
            }
        }
        
        fetchUsersAndReloadData()
        
        tableView.didScrollToLastGroupOfCells = { [weak self] lastUserID in
            self?.tableView.isLoading = true
            self?.fetchUsers(fromUserID: lastUserID) { users in
                DispatchQueue.main.async {
                    users.forEach{ self?.rowDataManager.save($0) }
                    self?.tableView.viewModel.allUsers += users
                    self?.tableView.isLoading = false
                }
            }
        }
        
        tableView.didSelectUserRow = { [weak self] user in
            let vc = ProfileViewController()
            vc.viewModel = ProfileViewModel(user: user)
            vc.saveNoteCompletion = { [weak self] (username, noteText) in
                self?.tableView.viewModel.userNotesDictionary[username] = noteText
                self?.tableView.reloadData()
            }
            vc.userProfileInfoDataManager = self?.profileInfoDataManager
            vc.userNoteDataManager = self?.noteDataManager
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func refresh() {
        fetchUsersAndReloadData()
    }
    
    private func fetchUsersAndReloadData() {
        fetchUsers() { [weak self] users in
            DispatchQueue.main.async {
                self?.replaceSavedUsers(with: users)
                self?.tableView.viewModel.allUsers = users
                self?.tableView.pageSize = users.count
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func loadUserRowDataFromDisk(completion: @escaping (([UserRowData])->())) {
        rowDataManager.retrieveAll { result in
            switch result {
            case .failure(_):
                completion([])
            case .success(let userRowArray):
                completion(userRowArray)
            }
        }
    }
    
    private func replaceSavedUsers(with newArray: [UserRowData]) {
        rowDataManager.clearAll { [weak self] success in
            guard success else { return }
            newArray.forEach{ self?.rowDataManager.save($0) }
        }
    }
    
    private func fetchUsers(fromUserID lastUserID: Int = 0, completion: @escaping ([UserRowData])->()) {
        let sessionProvider = SessionProvider()
        sessionProvider.request([UserRowData].self, service: UserService.getAll(lastUserID)) { result in
            switch result {
            case .failure(let err):
                print("Error || Failed to get users. \(err.localizedDescription)")
            case let .success(users):
                completion(users)
            }
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.viewModel.filterUsers(searchText: searchController.searchBar.text ?? "")
    }
}
