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

final class ArithmeticTriangleTests: XCTestCase {
  func testSubscript() {
    let t = ArithmeticTriangle<Int>()
    
    // First columns
    XCTAssertEqual(t[0, 0], 1)
    XCTAssertEqual(t[1, 0], 1)
    XCTAssertEqual(t[2, 0], 1)
    XCTAssertEqual(t[3, 0], 1)
    XCTAssertEqual(t[100, 0], 1)
    
    // Last columns
    XCTAssertEqual(t[1, 1], 1)
    XCTAssertEqual(t[2, 2], 1)
    XCTAssertEqual(t[3, 3], 1)
    XCTAssertEqual(t[100, 100], 1)
    
    // Second column
    XCTAssertEqual(t[2, 1], 2)
    XCTAssertEqual(t[3, 1], 3)
    XCTAssertEqual(t[42, 1], 42)
    XCTAssertEqual(t[100, 1], 100)
    
    // Penultimate column
    XCTAssertEqual(t[2, 1], 2)
    XCTAssertEqual(t[3, 2], 3)
    XCTAssertEqual(t[42, 41], 42)
    XCTAssertEqual(t[100, 99], 100)
    
    // Columns in the middle
    XCTAssertEqual(t[6, 2], 15)
    XCTAssertEqual(t[6, 3], 20)
    XCTAssertEqual(t[6, 4], 15)
    XCTAssertEqual(t[7, 2], 21)
    XCTAssertEqual(t[7, 3], 35)
    XCTAssertEqual(t[7, 4], 35)
    XCTAssertEqual(t[7, 5], 21)
  }
  
  func testSumOfIntegersInRow() {
    let t = ArithmeticTriangle<Int>()
    
    XCTAssertEqual(t.sumOfElements(in: 0), 1)
    XCTAssertEqual(t.sumOfElements(in: 1), 2)
    XCTAssertEqual(t.sumOfElements(in: 2), 4)
    XCTAssertEqual(t.sumOfElements(in: 3), 8)
    XCTAssertEqual(t.sumOfElements(in: 4), 16)
    XCTAssertEqual(t.sumOfElements(in: 5), 32)
    XCTAssertEqual(t.sumOfElements(in: 5), 32)
    
    XCTAssertEqual(t.sumOfElements(in: 49), 562949953421312)
  }
  
  func testSumOfSomeIntegersInRow() {
    let t = ArithmeticTriangle<Int>()
    
    // First columns
    XCTAssertEqual(t.sumOfElements(at: 0...0, in: 0), 1)
    XCTAssertEqual(t.sumOfElements(at: 0...0, in: 1), 1)
    XCTAssertEqual(t.sumOfElements(at: 0...0, in: 2), 1)
    
    // Last columns
    XCTAssertEqual(t.sumOfElements(at: 0...0, in: 0), 1)
    XCTAssertEqual(t.sumOfElements(at: 1...1, in: 1), 1)
    XCTAssertEqual(t.sumOfElements(at: 2...2, in: 2), 1)
    
    XCTAssertEqual(t.sumOfElements(at: 0...0, in: 0), 1)
    XCTAssertEqual(t.sumOfElements(at: 0...1, in: 1), 2)
    XCTAssertEqual(t.sumOfElements(at: 0...2, in: 2), 4)
    XCTAssertEqual(t.sumOfElements(at: 1...2, in: 2), 3)
    XCTAssertEqual(t.sumOfElements(at: 0...1, in: 2), 3)
    XCTAssertEqual(t.sumOfElements(at: 2...2, in: 4), 6)
    XCTAssertEqual(t.sumOfElements(at: 1...3, in: 4), 14)
    XCTAssertEqual(t.sumOfElements(at: 1...3, in: 5), 25)
    XCTAssertEqual(t.sumOfElements(at: 1...5, in: 5), 31)
    XCTAssertEqual(t.sumOfElements(at: 0...4, in: 5), 31)
    XCTAssertEqual(t.sumOfElements(at: 2...3, in: 5), 20)
    XCTAssertEqual(t.sumOfElements(at: 2...3, in: 6), 35)
    XCTAssertEqual(t.sumOfElements(at: 2...4, in: 6), 50)
  }
}
