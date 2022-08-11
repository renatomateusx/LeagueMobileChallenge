//
//  HomeViewModelTests.swift
//  LeagueMobileChallengeTests
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import XCTest
@testable import LeagueMobileChallenge

class HomeViewModelTests: XCTestCase {
    
    typealias Completion<T, R> = ((_ value: T?, _ value: R?) -> Void)
    var viewModel: HomeViewModel!
    var successCompletion: Completion<Any?, Any?>!
    var failureCompletion: Completion<Any?, Any?>!
    lazy var serviceMockSuccess: APIControllerMockSuccess = APIControllerMockSuccess()
    lazy var serviceMockFailure: APIControllerMockFailure = APIControllerMockFailure()
    
    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    func testFetchIfSuccess() {
        viewModel = HomeViewModel(with: serviceMockSuccess)
        viewModel?.delegate = self
        let expectation = XCTestExpectation.init(description: "Digio Data")
        self.successCompletion = { (users, posts) in
            if let posts = posts {
                XCTAssertNotNil(posts, "No data was downloaded.")
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        viewModel.fetchData()
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testFetchPostsIfFailure() {
        viewModel = HomeViewModel(with: serviceMockFailure)
        viewModel.delegate = self
        let expectation = XCTestExpectation.init(description: "Error")
        self.failureCompletion = { (nil, error) in
            if let error = error {
                XCTAssertNotNil(error, "No data was downloaded.")
                expectation.fulfill()
                
            } else {
                XCTFail()
            }
        }
        viewModel.fetchData()
        wait(for: [expectation], timeout: 60.0)
    }
}

extension HomeViewModelTests: HomeViewModelDelegate {
    func onSuccessFetchingWeather(users: Users, posts: Posts) {
        successCompletion(users, posts)
    }
    
    func onFailureFetchingWeather(error: Error) {
        failureCompletion(nil, error)
    }
}
