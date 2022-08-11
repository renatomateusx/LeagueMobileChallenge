//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

protocol APIControllerProtocol: AnyObject {
    func fetchUserToken(userName: String, password: String, completion: @escaping (String?, Error?) -> Void)
    func fetchPosts(completion: @escaping (Posts?, Error?) -> Void)
    func fetchUsers(completion: @escaping (Users?, Error?) -> Void)
}

class APIController: APIControllerProtocol {
    
    static let shared = APIController()
    
    fileprivate var userToken: String?
    private let endpoint = APIEndpoint()
    
    func fetchUserToken(userName: String = "", password: String = "", completion: @escaping (String?, Error?) -> Void) {
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(endpoint.loginPath, headers: headers).responseJSON { (response) in
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

    func fetchPosts(completion: @escaping (Posts?, Error?) -> Void) {

        request(url: endpoint.postPath) { data, error in
            completion(data, error)
        }

    }

    func fetchUsers(completion: @escaping (Users?, Error?) -> Void) {

        request(url: endpoint.userPath) { data, error in
            completion(data, error)
        }
    }
    
    private func request<T:Codable>(url: URL, completion: @escaping (T?, Error?) -> Void) {
        guard let userToken = userToken else {
            NSLog("No user token set")
            completion(nil, nil)
            return
        }
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
            if let data = response.data, let decoded = try? JSONDecoder().decode(T.self, from: data) {
                completion(decoded, response.error)
            } else {
                completion(nil, response.error)
            }
        }
    }
}
