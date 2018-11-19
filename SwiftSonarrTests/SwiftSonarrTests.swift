//
//  SwiftSonarrTests.swift
//  SwiftSonarrTests
//
//  Created by Eric Castillo on 11/11/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import XCTest
@testable import SwiftSonarr

class SwiftSonarrTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}




//private final class MockSonarr: Sonarr {
//    var getTagResult: Result<Tag>?
//
//    @objc override func tag(id: Int, _ completionHandler: @escaping (Result<Tag>) -> Void) {
//        completionHandler(getTagResult!)
//    }
//
//    func testSuccess() {
//        let appServerClient = MockAppServerClient()
//        appServerClient.getFriendsResult = .success(payload: [])
//
//        let viewModel = FriendsTableViewViewModel(appServerClient: appServerClient)
//        viewModel.getFriends()
//
//        guard case .some(.empty) = viewModel.friendCells.value.first else {
//            XCTFail()
//            return
//        }
//    }
//}
