//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Algorithms open source project
//
// Copyright (c) 2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import XCTest
import Algorithms

final class AdjacentPairsTests: XCTestCase {
  func testEmptySequence() {
    let pairs = (0...).prefix(0).adjacentPairs()
    XCTAssertEqualSequences(pairs, [], by: ==)
  }
  
  func testEmptySequenceWrapped() {
    let pairs = (0...).prefix(0).adjacentPairs(wrapping: true)
    XCTAssertEqualSequences(pairs, [], by: ==)
  }
  
  func testOneElementSequence() {
    let pairs = (0...).prefix(1).adjacentPairs()
    XCTAssertEqualSequences(pairs, [], by: ==)
  }
  
  func testOneElementSequenceWrapping() {
    let pairs = (0...).prefix(1).adjacentPairs(wrapping: true)
    XCTAssertEqualSequences(pairs, [(0, 0)], by: ==)
  }
  
  func testTwoElementSequence() {
    let pairs = (0...).prefix(2).adjacentPairs()
    XCTAssertEqualSequences(pairs, [(0, 1)], by: ==)
  }
  
  func testTwoElementSequenceWrapping() {
    let pairs = (0...).prefix(2).adjacentPairs(wrapping: true)
    XCTAssertEqualSequences(pairs, [(0, 1), (1, 0)], by: ==)
  }
  
  func testThreeElementSequence() {
    let pairs = (0...).prefix(3).adjacentPairs()
    XCTAssertEqualSequences(pairs, [(0, 1), (1, 2)], by: ==)
  }
  
  func testThreeElementSequenceWrapping() {
    let pairs = (0...).prefix(3).adjacentPairs(wrapping: true)
    XCTAssertEqualSequences(pairs, [(0, 1), (1, 2), (2, 0)], by: ==)
  }
  
  func testManySequences() {
    for n in 4...100 {
      let pairs = (0...).prefix(n).adjacentPairs()
      XCTAssertEqualSequences(pairs, zip(0..., 1...).prefix(n - 1), by: ==)
    }
  }
  
  func testManySequencesWrapping() {
    for n in 4...100 {
      let pairs = (0...).prefix(n).adjacentPairs(wrapping: true)
      XCTAssertEqualSequences(pairs, chain(zip(0..., 1...).prefix(n - 1), [((n - 1), 0)]), by: ==)
    }
  }
  
  func testZeroElements() {
    let pairs = (0..<0).adjacentPairs()
    XCTAssertEqual(pairs.startIndex, pairs.endIndex)
    XCTAssertEqualSequences(pairs, [], by: ==)
  }
  
  func testZeroElementsWrapping() {
    let pairs = (0..<0).adjacentPairs(wrapping: true)
    XCTAssertEqual(pairs.startIndex, pairs.endIndex)
    XCTAssertEqualSequences(pairs, [], by: ==)
  }
  
  func testOneElement() {
    let pairs = (0..<1).adjacentPairs()
    XCTAssertEqual(pairs.startIndex, pairs.endIndex)
    XCTAssertEqualSequences(pairs, [], by: ==)
  }
  
  func testOneElementWrapping() {
    let pairs = (0..<1).adjacentPairs(wrapping: true)
    XCTAssertEqualSequences(pairs, [(0, 0)], by: ==)
  }
  
  func testTwoElements() {
    let pairs = (0..<2).adjacentPairs()
    XCTAssertEqualSequences(pairs, [(0, 1)], by: ==)
  }
  
  func testTwoElementsWrapping() {
    let pairs = (0..<2).adjacentPairs(wrapping: true)
    XCTAssertEqualSequences(pairs, [(0, 1), (1, 0)], by: ==)
  }
  
  func testThreeElements() {
    let pairs = (0..<3).adjacentPairs()
    XCTAssertEqualSequences(pairs, [(0, 1), (1, 2)], by: ==)
  }
  
  func testThreeElementsWrapping() {
    let pairs = (0..<3).adjacentPairs(wrapping: true)
    XCTAssertEqualSequences(pairs, [(0, 1), (1, 2), (2, 0)], by: ==)
  }
  
  func testManyElements() {
    for n in 4...100 {
      let pairs = (0..<n).adjacentPairs()
      XCTAssertEqualSequences(pairs, zip(0..., 1...).prefix(n - 1), by: ==)
    }
  }
  
  func testManyElementsWrapping() {
    for n in 4...100 {
      let pairs = (0..<n).adjacentPairs(wrapping: true)
      XCTAssertEqualSequences(pairs, chain(zip(0..., 1...).prefix(n - 1), [((n - 1), 0)]), by: ==)
    }
  }
  
  func testIndexTraversals() {
    validateIndexTraversals(
      (0..<0).adjacentPairs(),
      (0..<1).adjacentPairs(),
      (0..<2).adjacentPairs(),
      (0..<5).adjacentPairs())
  }
  
  func testIndexTraversalsWrapping() {
    validateIndexTraversals(
      (0..<0).adjacentPairs(wrapping: true),
      (0..<1).adjacentPairs(wrapping: true),
      (0..<2).adjacentPairs(wrapping: true),
      (0..<5).adjacentPairs(wrapping: true))
  }
  
  func testLaziness() {
    XCTAssertLazySequence((0...).lazy.adjacentPairs())
    XCTAssertLazyCollection((0..<100).lazy.adjacentPairs())
  }
  
  func testLazinessWrapping() {
    XCTAssertLazySequence((0...).lazy.adjacentPairs(wrapping: true))
    XCTAssertLazyCollection((0..<100).lazy.adjacentPairs(wrapping: true))
  }
}