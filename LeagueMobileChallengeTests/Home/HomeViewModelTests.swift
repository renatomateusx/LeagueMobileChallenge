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
        viewModel.posts.bind { [unowned self] (_) in
            if let posts = viewModel.posts.value, let users = viewModel.users.value {
                successCompletion(users, posts)
            }
        }
        let expectation = XCTestExpectation.init(description: "Data")
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
        viewModel.error.bind { [unowned self] (_) in
            if let error = viewModel.error.value {
                failureCompletion(nil, error)
            }
        }
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
