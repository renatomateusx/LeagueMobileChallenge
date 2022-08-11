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

        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        setupView()
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
                                                       for: indexPath) as? PostTableViewCell else { fatalError(" Bad Cell - Could Not Cast! ") }
        let post = posts[indexPath.row]
        guard let user = viewModel.filterUserById(id: post.userID) else { return cell }
        cell.configure(post, user)

        return cell
    }
}

extension HomeTableViewController {
    
    private func setupView() {
        
        self.title = "Posts"
        
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

// MARK: - ViewControllerViewModelDelegate

extension HomeTableViewController: HomeViewModelDelegate {
    func onSuccessFetchingWeather(users: Users, posts: Posts) {
        self.users = users
        self.posts = posts
        self.reloadTableViewData()
    }
    
    func onFailureFetchingWeather(error: Error) {
        DispatchQueue.main.async {
            self.alert(title: "Oops!", message: error.localizedDescription)
        }
    }
}
