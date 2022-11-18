//
//  CatsTests.swift
//  CatsTests
//
//  Created by Alex Losikov on 11/17/22.
//

import XCTest
@testable import Cats

final class CatTests: XCTestCase {
    var cats: [Cat]!
    
    override func setUpWithError() throws {
        let data = try getData(fromJSON: "cats")
        cats = try JSONDecoder().decode([Cat].self, from: data)
    }

    override func tearDownWithError() throws {
        cats = nil
    }

    func testCount() throws {
        XCTAssertEqual(cats.count, 1114)
    }

    func testCatParser() throws {
        let cat = cats.first!
        XCTAssertEqual(cat.id, "rV1MVEh0Af2Bm4O0")
        XCTAssertEqual(cat.imageUrl(), "https://cataas.com/cat/rV1MVEh0Af2Bm4O0?w=200&h=200")
        XCTAssertEqual(cat.tags, ["kitten", "several", "gif"])
    }
}
