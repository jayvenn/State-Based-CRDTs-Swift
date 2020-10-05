//
//  AddOnlySetTests.swift
//  State-Based-LWW-Element-DictionaryTests
//
//  Created by Jayven Nhan on 10/5/20.
//

import XCTest
@testable import State_Based_LWW_Element_Dictionary

final class AddOnlySetTests: XCTestCase {
  func testEmptyInitialization() {
    let set = AddOnlySet()
    XCTAssertEqual(set.collection, [])
  }
  func testValueInitialization() {
    let value = "value"
    let set = AddOnlySet(collection: [value])
    XCTAssertEqual(set.collection, [value])
  }
  func testCollectionChange() {
    let value = "value"
    var set = AddOnlySet(collection: [value])
    let newValue = "new value"
    set.insert(newValue)
    XCTAssertEqual(set.collection, [value, newValue])
  }
  func testValueMerge() {
    let valueA = "a"
    let valueB = "b"
    let setA = AddOnlySet(collection: [valueA])
    let setB = AddOnlySet(collection: [valueB])
    let mergedSet = setA.merge(with: setB)
    XCTAssertEqual(mergedSet.collection, [valueA, valueB])
  }
  func testAssociative() {
    // (A + B) + C = A + (B + C)
    let setA = AddOnlySet(collection: ["a"])
    let setB = AddOnlySet(collection: ["b"])
    let setC = AddOnlySet(collection: ["c"])
    // (A + B) + C
    let lhsSet = setA.merge(with: setB).merge(with: setC)
    // A + (B + C)
    let rhsSet = setB.merge(with: setC).merge(with: setA)
    XCTAssertEqual(lhsSet.collection, rhsSet.collection)
  }
  func testCommutative() {
    // A + B = B + C
    let setA = AddOnlySet(collection: ["a"])
    let setB = AddOnlySet(collection: ["b"])
    let lhsSet = setA.merge(with: setB)
    let rhsSet = setB.merge(with: setA)
    XCTAssertEqual(lhsSet.collection, rhsSet.collection)
  }
  func testIdempotent() {
    let setA = AddOnlySet(collection: ["a"])
    let setB = AddOnlySet(collection: ["b"])
    let setC = setA.merge(with: setB)
    let setD = setC.merge(with: setB)
    let setE = setD.merge(with: setA)
    XCTAssertEqual(setC.collection, setE.collection)
  }
}
