//
//  APIControllerMockFailure.swift
//  LeagueMobileChallengeTests
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
@testable import LeagueMobileChallenge

class APIControllerMockFailure: APIControllerProtocol {
    func fetchUserToken(userName: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        completion(nil, NSError(domain: "Unauthorized",
                                  code: 401,
                                  userInfo: nil))
    }
    
    func fetchPosts(completion: @escaping (Posts?, Error?) -> Void) {
        completion(nil, NSError(domain: "Unauthorized",
                                  code: 401,
                                  userInfo: nil))
    }
    
    func fetchUsers(completion: @escaping (Users?, Error?) -> Void) {
        completion(nil, NSError(domain: "No data was downloaded.",
                                  code: 400,
                                  userInfo: nil))
    }
}
