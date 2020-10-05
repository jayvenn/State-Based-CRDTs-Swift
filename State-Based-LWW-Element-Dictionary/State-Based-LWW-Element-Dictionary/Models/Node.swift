//
//  Node.swift
//  State-Based-LWW-Element-Dictionary
//
//  Created by Jayven Nhan on 10/5/20.
//

import Foundation

struct Node: Comparable {
  let value: String
  let timestamp: TimeInterval

  static func < (lhs: Node, rhs: Node) -> Bool {
    lhs.timestamp < rhs.timestamp
  }

  // MATH
  // Associative: 1+(2+3) = (1+2)+3
  // Commutative: 2 + 3 + 4 = 4 + 3 + 2
  // Is Idempotent: max(x, 10)
  // Not idempotent: 3 + 1 ≠ 3 + 1 + 1
}
