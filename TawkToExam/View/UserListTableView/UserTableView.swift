//
//  UserTableView.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/18/21.
//

import UIKit


class UserTableView: UITableView {
    private let identifier = "userRow"
    var pageSize = 1
    
    var viewModel = UserTableViewModel()
    var hasInternet = true {
        didSet {
            self.beginUpdates()
            self.endUpdates()
        }
    }
    
    let loadingRow = LoadingTableCell()
    var isLoading = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.loadingRow.animateIndicator(self?.isLoading ?? false)
            }
        }
    }
    
    private var loadedPages = [1]
    
    /// completion gives lastItemNumLoaded
    var didScrollToLastGroupOfCells: ((Int)->()) = { _ in
        print("Log || No completion set for 'didScrollToLastGroupOfCells'")
    }
    /// completion gives username
    var didSelectUserRow: ((UserRowData)->()) = { _ in
        print("Log || No completion set for 'didSelectUserRow'")
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupTableView()
        viewModel.didUpdateUserList = { [weak self] in
            self?.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        register(UserRowStandard.self, forCellReuseIdentifier: viewModel.standardIdentifier)
        register(UserRowInverted.self, forCellReuseIdentifier: viewModel.invertedIdentifier)
        
        delegate = self
        dataSource = self
        separatorStyle = .none
    }
}

extension UserTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visibleUsers.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < viewModel.visibleUsers.count {
            return 76
        } else {
            return isLoading ? 20: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.visibleUsers.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.getIdentifier(for: indexPath.row)) as? UserRowProtocol
            else {
                return UITableViewCell()
            }
            cell.userImageView.image = UIImage()
            
            let user = viewModel.getUser(for: indexPath.row)
            cell.setupCellInfo(for: user)
            cell.userImageView.loadImage(from: user.avatarUrl)
            cell.setNoteIconVisibility(to: viewModel.checkNoteExistence(forUserIn: indexPath.row))
            return cell
        } else {
            return loadingRow
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.visibleUsers.count - 1 {
            let pageToBeRequested = Int(viewModel.visibleUsers.count/pageSize) + 1
            print("pageToBeRequested", pageToBeRequested)
            if !loadedPages.contains(pageToBeRequested) {
                didScrollToLastGroupOfCells(viewModel.lastUserIDFetched)
                loadedPages.append(pageToBeRequested)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.visibleUsers[indexPath.row]
        didSelectUserRow(user)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return NoInternetRedView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return hasInternet ? 0: 30
    }
}
