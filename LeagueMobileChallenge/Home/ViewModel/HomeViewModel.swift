//
//  HomeViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func onSuccessFetchingWeather(users: Users, posts: Posts)
    func onFailureFetchingWeather(error: Error)
}

class HomeViewModel {
    
    // MARK: - Private Properties
    var delegate: HomeViewModelDelegate?
    var users = Users()
    var posts = Posts()
    // MARK: - Inits
    
    
    func fetchData() {
        APIController.shared.fetchUserToken(userName: APIController.user, password: APIController.password) { token, error in
            if let error = error {
                // PRINT ERROR
                print(error)
                self.delegate?.onFailureFetchingWeather(error: error)
                return
            }
    
            APIController.shared.fetchUsers { usersData, error in
                if let error = error {
                    print(error)
                    self.delegate?.onFailureFetchingWeather(error: error)
                    return
                }
                
                if let usersData = usersData as? Data,
                    let users: Users = try? JSONDecoder().decode(Users.self, from: usersData) {
                    self.users = users
                    
                    APIController.shared.fetchPosts { postsData, error in
                        if let error = error {
                            print(error)
                            self.delegate?.onFailureFetchingWeather(error: error)
                            return
                        }
                        if let postsData = postsData as? Data,
                            let posts: Posts = try? JSONDecoder().decode(Posts.self, from: postsData) {
                            self.posts = posts
                            self.delegate?.onSuccessFetchingWeather(users: users, posts: posts)
                        }
                    }
                }
            }
            
        }
    }
}

extension HomeViewModel {
    func filterUserById(id: Int) -> User? {
        self.users.filter({ $0.id == id }).first
    }
}
