//
//  Node.swift
//  State-Based-LWW-Element-Dictionary
//
//  Created by Jayven Nhan on 10/5/20.
//

import Foundation

struct ReplicatingNode: Comparable {
  var value: String
  var timestamp = Date().timeIntervalSinceReferenceDate
  var id = UUID()

  static func < (lhs: ReplicatingNode, rhs: ReplicatingNode) -> Bool {
    lhs.timestamp < rhs.timestamp
  }

  mutating func merge(with replicatingNode: ReplicatingNode) -> ReplicatingNode {
    let lwwNode = max(self, replicatingNode)
    let newNode = ReplicatingNode(value: lwwNode.value)
    self = newNode
    return newNode
  }

  // MATH
  // Associative: 1+(2+3) = (1+2)+3
  // Commutative: 2 + 3 + 4 = 4 + 3 + 2
  // Is Idempotent: max(x, 10)
  // Not idempotent: 3 + 1 ≠ 3 + 1 + 1
}
