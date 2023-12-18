//
//  File.swift
//  
//
//  Created by Rozeri Dağtekin on 18.12.23.
//

import XCTest
@testable import SharedDataStructure

final class BinarySearchTestCase: XCTestCase {
    func test_binarySearch() {
        let array = [1, 5, 18, 32, 33, 33, 47, 49, 502]
        XCTAssertEqual(array.binarySearch(for: 5), 1)
    }

    func test_findIndices() {
        let array = [1, 2, 3, 3, 3, 4, 5, 5]
        XCTAssertEqual(findIndicesInBinarySearch(of: 3, in: array), 2..<5)
    }
}
