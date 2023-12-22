//
//  HeapTests.swift
//
//
//  Created by Rozeri Dağtekin on 18.12.23.
//

import XCTest
@testable import SharedDataStructure

final class HeapTests: XCTestCase {
    func test_peek() {
      let heap = Heap(unsortedInts, areSorted: >)
      XCTAssertEqual(heap.peek(), 12)
    }

    func test_removeRoot() {
      var heap = Heap(unsortedInts, areSorted: >)
      XCTAssertEqual(heap.removeRoot(), 12)
    }

    private let unsortedInts = [1, 12, 3, 4, 1, 6, 8, 7]
}
