//
//  WikiSearch11Tests.swift
//  WikiSearch11Tests
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import XCTest
@testable import WikiSearch11

class WikiSearch11Tests: XCTestCase {
    
    var searchResultsWorker: SearchAPIWorker!
    var expec = XCTestExpectation(description: "FetchList")

    override func setUp() {
        searchResultsWorker = SearchAPIWorker()
    }

    override func tearDown() {
        searchResultsWorker = nil
    }

    func testSearchResultsCall() throws {
        searchResultsWorker.loadSearchResultsInfo(body: "Doctor", productCount: "20", success: { [weak self](result) in
            if let queryItems = result.query?.pages, queryItems.count > 0 {
                self?.expec.fulfill()
                XCTAssert(true, "List of search results generated")
            }
        }, failure: { (error) in
            XCTFail(error.localizedDescription)
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
