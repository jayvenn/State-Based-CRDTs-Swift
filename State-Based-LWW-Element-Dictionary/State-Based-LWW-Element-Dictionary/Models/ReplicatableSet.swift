//
//  ReplicatableSet.swift
//  State-Based-LWW-Element-Dictionary
//
//  Created by Jayven Nhan on 10/5/20.
//

import Foundation

struct ReplicatableSet {
  struct Metadata {
    var isRemoved = false
    var timestamp = TimeInterval()
  }
  var metadataDict: [String: Metadata] = [:]
  var currentTimestamp = TimeInterval()
  var values: Set<String> {
    let strs = metadataDict
      .filter {
        !$1.isRemoved
      }
      .map {
        $0.key
      }
    return Set(strs)
  }
  init(strs: [String]) {
    for str in strs {
      _ = insert(str)
    }
  }
  mutating func insert(_ str: String) -> Bool {
    currentTimestamp += 1
    let metadata = Metadata(timestamp: currentTimestamp)
    var isNewInsertion = false
    if let collectedMetadata = metadataDict[str] {
      isNewInsertion = collectedMetadata.isRemoved
    }
    metadataDict[str] = metadata
    return isNewInsertion
  }
  mutating func remove(_ str: String) -> String? {
    guard
      let collectedMetadata = metadataDict[str],
      !collectedMetadata.isRemoved
    else { return nil }
    currentTimestamp += 1
    var metadata =
      Metadata(timestamp: currentTimestamp)
    metadata.isRemoved = true
    metadataDict[str] = metadata
    return str
  }
  func contains(_ str: String) -> Bool {
    guard let collectedMetadata = metadataDict[str] else { return false }
    return !collectedMetadata.isRemoved
  }
  func merge(with replicatableSet: ReplicatableSet) -> ReplicatableSet {
    var result = self
    result.metadataDict = replicatableSet.metadataDict.reduce(into: metadataDict) { result, dict in
      let currentDictValue = dict.value
      guard let resultDictValue = result[dict.key] else {
        result[dict.key] = currentDictValue
        return
      }
      result[dict.key] = resultDictValue
    }
    result.currentTimestamp = max(currentTimestamp, replicatableSet.currentTimestamp)
    return result
  }
}
