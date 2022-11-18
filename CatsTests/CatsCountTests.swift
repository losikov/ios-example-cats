//
//  CatsCountTests.swift
//  CatsTests
//
//  Created by Alex Losikov on 11/17/22.
//

import XCTest
@testable import Cats

final class CatsCountTests: XCTestCase {
    var catsCount: CatsCount!
    
    override func setUpWithError() throws {
        let data = try getData(fromJSON: "count")
        catsCount = try JSONDecoder().decode(CatsCount.self, from: data)
    }

    override func tearDownWithError() throws {
        catsCount = nil
    }

    func testCatsCount() throws {
        XCTAssertEqual(catsCount.number, 1114)
    }
}
