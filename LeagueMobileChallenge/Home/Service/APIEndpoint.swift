//
//  APIEndpoint.swift
//  LeagueMobileChallenge
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation

struct APIEndpoint {

    private var host: String {
        return Constants.baseURL
    }
    
    var loginPath: URL {
        return URL(string: "\(host)login")!
    }
    
    var postPath: URL {
        return URL(string: "\(host)posts")!
    }
    
    var userPath: URL {
        return URL(string: "\(host)users")!
    }

    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
