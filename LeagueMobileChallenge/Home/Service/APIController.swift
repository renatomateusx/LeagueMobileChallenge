//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

class APIController {
    static let user = "user"
    static let password = "password"
    
    static let domain = "https://engineering.league.dev/challenge/api/"
    private let loginAPI = domain + "login"
    private let postAPI = domain + "posts"
    private let userAPI = domain + "users"
    
    static let shared = APIController()
    
    fileprivate var userToken: String?
    
    func fetchUserToken(userName: String = "", password: String = "", completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: loginAPI) else {
            return
        }
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(url, headers: headers).responseJSON { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            if let value = response.result.value as? [AnyHashable : Any] {
                self.userToken = value["api_key"] as? String
            }
            completion(self.userToken, nil)
        }
    }

    func fetchPosts(completion: @escaping (Any?, Error?) -> Void) {
        guard let url = URL(string: postAPI) else {
            return
        }

        request(url: url) { data, error in
            completion(data, error)
        }

    }

    func fetchUsers(completion: @escaping (Any?, Error?) -> Void) {
        guard let url = URL(string: userAPI) else {
            return
        }

        request(url: url) { data, error in
            completion(data, error)
        }
    }
    
    func request(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        guard let userToken = userToken else {
            NSLog("No user token set")
            completion(nil, nil)
            return
        }
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
            completion(response.data, response.error)
        }
    }
}
