//
//  HomeTableViewController.swift
//  LeagueMobileChallenge
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var posts = Posts()
    var users = Users()
    var viewModel = HomeViewModel(with: APIController.shared)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setupView()
        setupObservers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                       for: indexPath) as? PostTableViewCell else { fatalError(.localized(.badCellCouldntCast)) }
        let post = posts[indexPath.row]
        guard let user = viewModel.filterUserById(id: post.userID) else { return cell }
        cell.configure(post, user)

        return cell
    }
}

extension HomeTableViewController {
    
    private func setupView() {
        
        self.title = .localized(.homeTitle)
    }
    
    private func setupObservers() {
        
        viewModel.posts.bind { [weak self] (_) in
            if let posts = self?.viewModel.posts.value,
               let users = self?.viewModel.users.value {
                
                self?.users = users
                self?.posts = posts
                self?.reloadTableViewData()
            }
        }
        
        viewModel.error.bind { [weak self] (_) in
            if let error = self?.viewModel.error.value {
                DispatchQueue.main.async {
                    self?.alert(title: .localized(.oopsTitle), message: error.localizedDescription)
                }
            }
        }
        
        setupData()
    }
    
    private func setupData() {
        loadingIndicator.startAnimating()
        viewModel.fetchData()
        
    }
}

extension HomeTableViewController {
    private func reloadTableViewData() {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.removeFromSuperview()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
