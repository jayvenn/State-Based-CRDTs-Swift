//
//  Node.swift
//  State-Based-LWW-Element-Dictionary
//
//  Created by Jayven Nhan on 10/5/20.
//

import Foundation

struct ReplicatingNode: Hashable {
  // MARK: - Properties
  var value: String
  var timestamp = Date().timeIntervalSinceReferenceDate
  var id = UUID()

  // MARK: - Mutating methods
  mutating func merge(with replicatingNode: ReplicatingNode) -> ReplicatingNode {
    let lwwNode = max(self, replicatingNode)
    let newNode = ReplicatingNode(value: lwwNode.value, timestamp: lwwNode.timestamp, id: lwwNode.id)
    self = newNode
    return newNode
  }
}

// MARK: - Comparable
extension ReplicatingNode: Comparable {
  static func < (lhs: ReplicatingNode, rhs: ReplicatingNode) -> Bool {
    lhs.timestamp < rhs.timestamp
  }
}

// MARK: - CustomStringConvertible
extension ReplicatingNode: CustomStringConvertible {
  var description: String {
    "\(value) created at \(timestamp)"
  }
}
