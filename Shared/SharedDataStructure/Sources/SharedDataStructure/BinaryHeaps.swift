//
//  File.swift
//  
//
//  Created by Rozeri Dağtekin on 18.12.23.
//

import Foundation
struct Heap<Element: Equatable> {
  private var elements: [Element] = []
  let areSorted: (Element, Element) -> Bool

  init(_ elements: [Element], areSorted: @escaping (Element, Element) -> Bool) {
    self.areSorted = areSorted
    self.elements = elements

    guard !elements.isEmpty else {
      return
    }

    for index in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
      siftDown(from: index)
    }
  }

  var isEmpty: Bool {
    return elements.isEmpty
  }

  var count: Int {
    return elements.count
  }

  func peek() -> Element? {
    return elements.first
  }

  func getChildIndices(ofParentAt parentIndex: Int) -> (left: Int, right: Int) {
    let leftIndex = (2 * parentIndex) + 1
    return (leftIndex, leftIndex + 1)
  }

  func getParentIndex(ofChildAt index: Int) -> Int {
    return (index - 1) / 2
  }

  mutating func removeRoot() -> Element? {
    guard !isEmpty else {
      return nil
    }

    elements.swapAt(0, count - 1)
    let originalRoot = elements.removeLast()
    siftDown(from: 0)
    return originalRoot
  }

  mutating func siftDown(from index: Int) {
    var parentIndex = index
    while true {
      let (leftIndex, rightIndex) = getChildIndices(ofParentAt: parentIndex)
      var optionalParentSwapIndex: Int?
      if leftIndex < count
        && areSorted(elements[leftIndex], elements[parentIndex])
      {
        optionalParentSwapIndex = leftIndex
      }
      if rightIndex < count
        && areSorted(elements[rightIndex], elements[optionalParentSwapIndex ?? parentIndex])
      {
        optionalParentSwapIndex = rightIndex
      }
      guard let parentSwapIndex = optionalParentSwapIndex else {
        return
      }
      elements.swapAt(parentIndex, parentSwapIndex)
      parentIndex = parentSwapIndex
    }
  }
}
