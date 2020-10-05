//
//  ReplicatingNode.swift
//  State-Based-LWW-Element-DictionaryTests
//
//  Created by Jayven Nhan on 10/5/20.
//

import XCTest
@testable import State_Based_LWW_Element_Dictionary

final class ArrayTests: XCTestCase {
  func testInitializationWithValue() {
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
    // (A + B) + C = A + (B + C)
    var nodeA = ReplicatingNode(value: "a", timestamp: 1)
    var nodeB = ReplicatingNode(value: "b", timestamp: 2)
    let nodeC = ReplicatingNode(value: "c", timestamp: 3)
    // (A + B) + C
    var lhsNode = nodeA.merge(with: nodeB)
    _ = lhsNode.merge(with: nodeC)
    // A + (B + C)
    var rhsNode = nodeB.merge(with: nodeC)
    _ = rhsNode.merge(with: nodeA)
    XCTAssertEqual(lhsNode.value, rhsNode.value)
  }
  func testCommutative() {
    // A + B = B + C
    var nodeA = ReplicatingNode(value: "a", timestamp: 1)
    var nodeB = ReplicatingNode(value: "b", timestamp: 2)
    let nodeC = nodeA.merge(with: nodeB)
    let nodeD = nodeB.merge(with: nodeA)
    XCTAssertEqual(nodeC.value, nodeD.value)
  }
  func testIdempotent() {
    var nodeA = ReplicatingNode(value: "a", timestamp: 1)
    let nodeB = ReplicatingNode(value: "b", timestamp: 2)
    var nodeC = nodeA.merge(with: nodeB)
    var nodeD = nodeC.merge(with: nodeB)
    let nodeE = nodeD.merge(with: nodeA)
    XCTAssertEqual(nodeB.value, nodeE.value)
  }
  func testCustomStringConvertible() {
    let value = "a"
    let timestamp: TimeInterval = 1
    let nodeA = ReplicatingNode(value: value, timestamp: timestamp)
    XCTAssertEqual(nodeA.description, "\(value) created at \(timestamp)")
  }
}
