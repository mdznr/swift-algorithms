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
@testable import Algorithms

final class RangeContainsRangeTests: XCTestCase {
  func testRangeAndRange() {
    // Contains
    XCTAssertTrue((0..<20).contains(2..<8))
    XCTAssertTrue((0..<20).contains(1..<9))
    XCTAssertTrue((0..<20).contains(0..<20))
    XCTAssertTrue((0..<20).contains(0..<10))
    XCTAssertTrue((0..<20).contains(10..<20))
    
    // Doesn’t contain
    XCTAssertFalse((0..<20).contains(0..<21))
    XCTAssertFalse((0..<20).contains(-1..<20))
    XCTAssertFalse((0..<20).contains(-1..<19))
    XCTAssertFalse((0..<20).contains(-1..<21))
    XCTAssertFalse((0..<20).contains(20..<21))
    XCTAssertFalse((0..<20).contains(20..<22))
    XCTAssertFalse((0..<20).contains(21..<32))
    
    // Empty ranges
    XCTAssertFalse((0..<20).contains(1..<1))
    XCTAssertFalse((0..<0).contains(1..<1))
    XCTAssertFalse((0..<0).contains(1..<10))
    XCTAssertFalse((0..<0).contains(-1..<10))
    XCTAssertFalse((-1..<10).contains(0..<0))
    XCTAssertFalse((0..<20).contains(20..<20))
  }
  
  func testRangeAndClosedRange() {
    // Contains
    XCTAssertTrue((0..<20).contains(2...8))
    XCTAssertTrue((0..<20).contains(1...9))
    XCTAssertTrue((0..<20).contains(0...19))
    XCTAssertTrue((0..<20).contains(0...10))
    XCTAssertTrue((0..<20).contains(10...19))
    
    // Doesn’t contain
    XCTAssertFalse((0..<20).contains(0...21))
    XCTAssertFalse((0..<20).contains(-1...20))
    XCTAssertFalse((0..<20).contains(-1...19))
    XCTAssertFalse((0..<20).contains(-1...21))
    XCTAssertFalse((0..<20).contains(20...21))
    XCTAssertFalse((0..<20).contains(20...22))
    XCTAssertFalse((0..<20).contains(21...32))
    
    // Empty ranges
    XCTAssertFalse((0..<0).contains(1...1))
    XCTAssertFalse((0..<0).contains(1...10))
    XCTAssertFalse((0..<0).contains(-1...10))
  }
  
  func testClosedRangeAndClosedRange() {
    // Contains
    XCTAssertTrue((0...20).contains(2...8))
    XCTAssertTrue((0...20).contains(1...9))
    XCTAssertTrue((0...20).contains(0...20))
    XCTAssertTrue((0...20).contains(0...10))
    XCTAssertTrue((0...20).contains(10...20))
    
    // Doesn’t contain
    XCTAssertFalse((0...20).contains(0...21))
    XCTAssertFalse((0...20).contains(-1...20))
    XCTAssertFalse((0...20).contains(-1...19))
    XCTAssertFalse((0...20).contains(-1...21))
    XCTAssertFalse((0...20).contains(20...21))
    XCTAssertFalse((0...20).contains(20...22))
    XCTAssertFalse((0...20).contains(21...32))
  }
}
