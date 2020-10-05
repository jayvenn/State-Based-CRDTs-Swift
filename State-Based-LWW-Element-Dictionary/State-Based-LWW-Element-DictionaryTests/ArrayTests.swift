//
//  ArrayTests.swift
//  State-Based-LWW-Element-DictionaryTests
//
//  Created by Jayven Nhan on 10/5/20.
//

import XCTest
@testable import State_Based_LWW_Element_Dictionary

final class ArrayTests: XCTestCase {
  func testInitialization() {
    let value = "value"
    let node = ReplicatingNode(value: value)
    XCTAssertEqual(node.value, value)
  }
  func testValueChange() {
    let value = "value"
    var node = ReplicatingNode(value: value)
    let newValue = "new value"
    node.value = newValue
    XCTAssertEqual(node.value, newValue)
  }
  func testValueMerge() {
    var nodeA = ReplicatingNode(value: "a")
    let nodeB = ReplicatingNode(value: "b")
    let mergedNode = nodeA.merge(with: nodeB)
    XCTAssertEqual(mergedNode.value, nodeB.value)
  }
  func testLastWriteWins() {
    var nodeA = ReplicatingNode(value: "a")
    let nodeB = ReplicatingNode(value: "b")
    nodeA.value = "c"
    let mergedNode = nodeA.merge(with: nodeB)
    XCTAssertEqual(mergedNode.value, nodeA.value)
  }
  func testAssociative() {
    var nodeA = ReplicatingNode(value: "a")
  }
  func testCommutative() {
  }
  func testIdempotent() {
  }
}
