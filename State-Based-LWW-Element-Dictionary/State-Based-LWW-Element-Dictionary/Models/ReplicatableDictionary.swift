//
//  ReplicatableDictionary.swift
//  State-Based-LWW-Element-Dictionary
//
//  Created by Jayven Nhan on 10/5/20.
//

import Foundation

struct ReplicatableDictionary<K, V> where K: Hashable {
  struct Metadata: Comparable {
    var value: V
    var timestamp = TimeInterval()
    var isRemoved = false
    static func < (lhs: ReplicatableDictionary<K, V>.Metadata, rhs: ReplicatableDictionary<K, V>.Metadata) -> Bool {
      lhs.timestamp < rhs.timestamp
    }
    static func == (lhs: ReplicatableDictionary<K, V>.Metadata, rhs: ReplicatableDictionary<K, V>.Metadata) -> Bool {
      lhs.timestamp == rhs.timestamp
    }
  }
  var metadataDict: [K: Metadata]
  var timestamp = TimeInterval()

  subscript(key: K) -> V? {
    get {
      guard
        let metadata = metadataDict[key],
        !metadata.isRemoved
      else { return nil }
      return metadata.value
    } set {
      timestamp += 1
      if let newValue = newValue {
        let metadata = Metadata(value: newValue, timestamp: timestamp)
        metadataDict[key] = metadata
      } else if let oldMetadata = metadataDict[key] {
        let metadata = Metadata(value: oldMetadata.value, timestamp: timestamp, isRemoved: true)
        metadataDict[key] = metadata
      }
    }
  }

  private var existingKeyValuePairs: [(key: K, value: V)] {
    metadataDict.filter { !$0.value.isRemoved }
  }

  var values: [V] {
    let values = existingKeyValuePairs.map { $0.value }
      return values
  }

  var keys: [K] {
      let keys = existingKeyValuePairs.map({ $0.key })
      return keys
  }

  var dictionary: [K : V] {
      existingKeyValuePairs.reduce(into: [:]) { result, pair in
          result[pair.key] = pair.value.value
      }
  }

  public var count: Int {
      valueContainersByKey.reduce(0) { result, pair in
          result + (pair.value.isDeleted ? 0 : 1)
      }
  }

//  func merge(with other: ReplicatableDictionary) -> ReplicatableDictionary {
//      var result = self
//      result.metadataDict = other.metadataDict.reduce(into: metadataDict) { result, entry in
//          let firstValueContainer = result[entry.key]
//          let secondValueContainer = entry.value
//          if let firstValueContainer = firstValueContainer {
//              result[entry.key] = firstValueContainer.timestamp > secondValueContainer.timestamp ? firstValueContainer : secondValueContainer
//          } else {
//              result[entry.key] = secondValueContainer
//          }
//      }
//      result.timestamp = max(timestamp, other.timestamp)
//      return result
//  }

  func merge(with replicatableDictionary: ReplicatableDictionary) {
    var isTimeIncremented = false
    var resultReplicatableDictionary = self
    resultReplicatableDictionary.timestamp = max(replicatableDictionary.timestamp, replicatableDictionary.timestamp)
    resultReplicatableDictionary.metadataDict = replicatableDictionary.metadataDict.reduce(into: metadataDict) {
      result, dict in
      let currentDictValue = dict.value
      guard let resultDictValue = result[dict.key] else {
        result[dict.key] = currentDictValue
        return
      }
      guard
        !currentDictValue.isRemoved,
        !resultDictValue.isRemoved else {
        result[dict.key] = max(resultDictValue, currentDictValue)
        return
      }
      if !isTimeIncremented {
        resultReplicatableDictionary.timestamp += 1
        isTimeIncremented = true
      }

      resultReplicatableDictionary.merge(with: dict.value.value as! ReplicatableDictionary<K, V>)
      let mergedValue = resultDictValue.merge(with: currentDictValue)
      let metadata = Metadata(value: mergedValue, timestamp: resultDictValue.timestamp)
      result[dict.key] = metadata
    }
    return result
  }
}

// MARK: - Comparable


extension ReplicatableDictionary: Codable where V: Codable, K: Codable {
}

extension ReplicatableDictionary.Metadata: Codable where V: Codable, K: Codable {
}

extension ReplicatableDictionary: Equatable where V: Equatable {
}

extension ReplicatableDictionary.Metadata: Equatable where V: Equatable {
}

extension ReplicatableDictionary: Hashable where V: Hashable {
}

extension ReplicatableDictionary.Metadata: Hashable where V: Hashable {
}
