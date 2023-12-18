import XCTest
@testable import SharedDataStructure

final class BinaryTreeTests: XCTestCase {
    func test_traverseInOrder() {
        let tree = makeTree()
        var traversedInOrderArray: [Int] = []
        tree.traverseInOrder { traversedInOrderArray.append($0) }
        XCTAssertEqual(traversedInOrderArray, [0,1,5,7,8,9])
    }

    func test_traversePreOrder() {
        let tree = makeTree()
        var traversedPreOrderArray: [Int] = []
        tree.traversePreOrder { traversedPreOrderArray.append($0) }
        XCTAssertEqual(traversedPreOrderArray, [7,1,0,5,9,8])
    }

    func test_traversePostOrder() {
        let tree = makeTree()
        var traversedPostOrderArray: [Int] = []
        tree.traversePostOrder { traversedPostOrderArray.append($0) }
        XCTAssertEqual(traversedPostOrderArray, [0,5,1,8,9,7])
    }

    func test_serialize_inPreOrderTraverse() {
        let tree = makeTree()

        let serializedTree = serialize(tree)
        XCTAssertEqual(serializedTree, [7,1,0,5,9,8])

        let deserializedArray = deserialize(serializedTree)
      //  XCTAssertEqual(deserializedArray, tree)
    }

    func serialize<T>(_ node: BinaryNode<T>) -> [T?] {
        var array: [T] = []
        node.traversePreOrder { array.append($0) }
        return array
    }

    func deserialize<T>(_ array: inout [T?]) -> BinaryNode<T>? {
        guard !array.isEmpty, let value = array.removeLast() else {
        return nil
      }

      let node = BinaryNode(value: value)
      node.leftChild = deserialize(&array)
      node.rightChild = deserialize(&array)
      return node
    }

    func deserialize<T>(_ array: [T?]) -> BinaryNode<T>? {
      var reversed = Array(array.reversed())
      return deserialize(&reversed)
    }

    func makeTree() -> BinaryNode<Int> {
        let tree = BinaryNode(value: 7)

        let leftTree = BinaryNode(value: 1)
        leftTree.leftChild = BinaryNode(value: 0)
        leftTree.rightChild = BinaryNode(value: 5)

        let rightTree = BinaryNode(value: 9)
        rightTree.leftChild = BinaryNode(value: 8)
        // right tree has no right child

        tree.leftChild = leftTree
        tree.rightChild = rightTree

        print(tree.description)
        return tree
    }
}
