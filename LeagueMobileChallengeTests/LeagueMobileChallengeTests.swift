//
//  LeagueMobileChallengeTests.swift
//  LeagueMobileChallengeTests
//
//  Created by Kelvin Lau on 2019-01-09.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import XCTest
import UIKit
import SnapshotTesting

@testable import LeagueMobileChallenge

class LeagueMobileChallengeTests: XCTestCase {
    
    var viewController: HomeTableViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        viewController = storyboard.instantiateViewController(withIdentifier: "HomeTableViewController") as? HomeTableViewController
        viewController.viewModel = HomeViewModel(with: APIControllerMockSuccess())
        viewController.loadViewIfNeeded()
        
        window = UIApplication.shared.windows.first
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialState() {
        sleep(3)
        XCTAssertEqual(viewController.posts.count, 1)
        XCTAssertEqual(viewController.title, "Posts")
        
        sleep(3)
        XCTAssertFalse(viewController.loadingIndicator.isAnimating)
        assertSnapshot(matching: viewController, as: .image(precision: 0.99))
    }
    
}
