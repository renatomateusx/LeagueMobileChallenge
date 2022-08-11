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
    let service: APIControllerProtocol
    var delegate: HomeViewModelDelegate?
    var users = Users()
    var posts = Posts()
    
    // MARK: - Inits
    
    init(with service: APIControllerProtocol) {
        self.service = service
    }
    
    func fetchData() {
        service.fetchUserToken(userName: Constants.user, password: Constants.password) { token, error in
            if let error = error {
                // PRINT ERROR
                print(error)
                self.delegate?.onFailureFetchingWeather(error: error)
                return
            }
    
            self.service.fetchUsers { users, error in
                if let error = error {
                    print(error)
                    self.delegate?.onFailureFetchingWeather(error: error)
                    return
                }
                
                if let usersData = users {
                    self.users = usersData
                    
                    self.service.fetchPosts { postsData, error in
                        if let error = error {
                            print(error)
                            self.delegate?.onFailureFetchingWeather(error: error)
                            return
                        }
                        if let postsData = postsData {
                            self.posts = postsData
                            self.delegate?.onSuccessFetchingWeather(users: self.users, posts: self.posts)
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
