//
//  ReplicatingRegister.swift
//  State-Based-LWW-Element-Dictionary
//
//  Created by Jayven Nhan on 10/5/20.
//

struct ReplicatingRegister<T> {
  struct Entry: Identifiable {
    var value: T
    var timestamp: TimeInterval
    var id: UUID
    init(
      value: T,
      timestamp: TimeInterval =
        Date().timeIntervalSinceReferenceDate,
      id: UUID = UUID()
    ) {
      self.value = value
      self.timestamp = timestamp
      self.id = id
    }
    func isOrdered(after other: Entry) -> Bool {
      (timestamp, id.uuidString) >
        (other.timestamp, other.id.uuidString)
    }
  }
  private var entry: Entry
  public var value: T {
    get {
      entry.value
    }
    set {
      entry = Entry(value: newValue)
    }
  }
  public init(_ value: T) {
    entry = Entry(value: value)
  }
}
