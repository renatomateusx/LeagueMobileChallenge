//
//  APIControllerMockSuccess.swift
//  LeagueMobileChallengeTests
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
@testable import LeagueMobileChallenge

class APIControllerMockSuccess: APIControllerProtocol {
    func fetchUserToken(userName: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        completion("mocked_token", nil)
    }
    
    func fetchPosts(completion: @escaping (Posts?, Error?) -> Void) {
        var posts = Posts()
        posts.append(Post(userID: 1, id: 1, title: "title post", body: "body post"))
        completion(posts, nil)
    }
    
    func fetchUsers(completion: @escaping (Users?, Error?) -> Void) {
        var users = Users()
        users.append(User(id: 1, avatar: "avatar", name: "name", username: "username", email: "email",
                          address: Address(street: "street", suite: "suite",
                                           city: "city", zipcode: "zipcode",
                                           geo: Geo(lat: "lat", lng: "lng")),
                          phone: "phone", website: "website", company: Company(name: "Company",
                                                                               catchPhrase: "catchPrase", bs: "bs")))
        completion(users, nil)
    }
}
