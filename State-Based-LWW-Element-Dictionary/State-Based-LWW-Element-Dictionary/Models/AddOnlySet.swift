//
//  AddOnlySet.swift
//  State-Based-LWW-Element-Dictionary
//
//  Created by Jayven Nhan on 10/5/20.
//

import Foundation

struct AddOnlySet {
  // MARK: - Properties
  private(set) var collection = Set<String>()

  // MARK: - Mutating methods
  mutating func insert(_ value: String) {
    collection.insert(value)
  }

  // MARK: - Operation methods
  func merge(with addOnlySet: AddOnlySet) -> AddOnlySet {
    AddOnlySet(collection: collection.union(addOnlySet.collection))
  }
}
