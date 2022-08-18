//
//  HomeViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func fetchData()
    
    var users: Bindable<Users> { get set }
    var posts: Bindable<Posts> { get set }
    var error: Bindable<Error> { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Private Properties
    let service: APIControllerProtocol
    var users = Bindable<Users>()
    var posts = Bindable<Posts>()
    var error = Bindable<Error>()
    
    // MARK: - Inits
    
    init(with service: APIControllerProtocol) {
        self.service = service
    }
    
    func fetchData() {
        service.fetchUserToken(userName: Constants.user, password: Constants.password) { token, error in
            if let error = error {
                // PRINT ERROR
                print(error)
                self.error.value = error
                return
            }
    
            self.service.fetchUsers { users, error in
                if let error = error {
                    print(error)
                    self.error.value = error
                    return
                }
                
                if let usersData = users {
                    self.users.value = usersData
                    
                    self.service.fetchPosts { postsData, error in
                        if let error = error {
                            print(error)
                            self.error.value = error
                            return
                        }
                        if let postsData = postsData {
                            self.posts.value = postsData
                        }
                    }
                }
            }
            
        }
    }
}

extension HomeViewModel {
    func filterUserById(id: Int) -> User? {
        guard let users = self.users.value else { return nil }
        return users.filter({ $0.id == id }).first
    }
}
