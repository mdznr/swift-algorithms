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

/// Also known as Pascal’s Triangle, the arithmetic triangle has many
/// applications in mathematics, particularly its ability to facilitate
/// combinatorial calculations.
///
/// A diagram showing the triangle with rows 0 through 7:
///
/// 0:   1
/// 1:   1  1
/// 2:   1  2  1
/// 3:   1  3  3  1
/// 4:   1  4  6  4  1
/// 5:   1  5 10 10  5  1
/// 6:   1  6 15 20 15  6  1
/// 7:   1  7 21 35 35 21  7  1
/// …
///
/// The triangle has an infinite number of rows. The number of columns in a row
/// is one more than the row’s index (an equilateral triangle). For example, the
/// number of columns in row index 5 is 6.
///
/// Construction:
///
/// In row 0, there is only one value: 1. Elements in each subsequent row are
/// the sums of the number above (previous row) and the number above and to the
/// left (previous row and previous column). If there is no value above or to
/// the left (a blank entry), assume 0. For example, the value in row index 5,
/// column index 2 is 6, which is the sum of the numbers at row 4, column 2 (6),
/// and row 4, column 1 (4).
///
/// There are many emergent properties from this simple construction.
/// `ArithmeticTriangle` provides easy access to some of them.
///
/// - Note: While an arithmetic triangle can be constructed of any element
/// conforming to `AdditiveArithmetic`, there are a number of shortcuts used for
/// performance purposes that can only be performed on elements conforming to
/// `BinaryInteger`.
public struct ArithmeticTriangle<Element: AdditiveArithmetic> {
  /// The start of the triangle. For integers, this is 1.
  public let base: Element
  
  /// A cache that stores the element at the given index. This dramatically
  /// improves performance by using memoization in the subscript and other
  /// functions.
  /// - Note: Not all values need to be cached. For example, values on the ends
  /// of the the triangle can be computed in O(1) anyways, so they need not be
  /// stored. Additionally, since the triangle is horizontally symmetrical,
  /// elements on the right half of the triangle need not be stored either.
  @usableFromInline
  internal var cache = [Index: Element]()
  
  init(base: Element) {
    self.base = base
  }
}

extension ArithmeticTriangle where Element: BinaryInteger {
  init() {
    self.init(base: 1)
  }
}

// MARK: - Basic Patterns and Properties

extension ArithmeticTriangle {
  /// Returns the number of columns in a given row
  /// - Parameter row: The row to get the number of columns for
  /// - Returns: The number of columns in a given row or `0` if the row is
  /// invalid (negative).
  /// - Complexity: O(1)
  @inlinable
  public static func numberOfColumns(in row: Int) -> Int {
    guard row >= 0 else { return 0 }
    
    // The triangle is equilateral (equal width and height), so the number of
    // columns is one more than the than the row’s index (since it starts at 0).
    return (row + 1)
  }
  
  /// Returns the sum of all the elements in a given row
  /// - Parameter row: The row to get the sum of all elements for
  /// - Note: This implementation is generic. An optimized version for elements
  /// conforming to `BinaryInteger` is implemented separately.
  /// - Complexity: <#Complexity#>
  @inlinable
  public func sumOfElements(in row: Int) -> Element {
    switch row {
      case 0:
        return self.base
        
      case ..<4:
        let sumOfPreviousRow = self.sumOfElements(in: row - 1)
        return sumOfPreviousRow + sumOfPreviousRow
        
      default:
        // Calculate the index of the mid point for this row.
        let (midPoint, remainder) = Self.numberOfColumns(in: row).quotientAndRemainder(dividingBy: 2)
        
        // Get the sum of the elements on one half of the triangle.
        let symmetricalHalf = (0..<midPoint).map({
          let index = Index(row: row, column: $0)
          return self[index]
        }).reduce(Element.zero, +)
        
        // Double the sum of one half of the triangle.
        let symmetricalSum = (symmetricalHalf + symmetricalHalf)
        
        // If the number of columns is even (no remainder), then there is no
        // column perfectly in the middle of the row, so the sum can be returned
        // as-is. Otherwise, calculate the value at the mid point and add it to
        // the left and right halves.
        if remainder == 0 {
          return symmetricalSum
        } else {
          let midPointIndex = Index(row: row, column: midPoint)
          let midPointElement = self[midPointIndex]
          return (symmetricalSum + midPointElement)
        }
    }
  }
  
  /// Returns the sum of the elements at the given columns in a given row
  /// - Parameters:
  ///   - columns: The columns in the row to get a sum of
  ///   - row: The row to sum elements in
  /// - Complexity: <#Complexity#>
  public func sumOfElements<R: RangeExpression>(
    at columns: R,
    in row: Int
  ) -> Element where R.Bound == Int {
    // Convert `RangeExpression<Int>` to `Range<Int>`.
    let columnRange = columns.relative(to: 0 ..< .max)
    
    func sumOfElements<C: Collection>(
      at columns: C
    ) -> Element where C.Element == Int {
      return columns.map({
        let index = Index(row: row, column: $0)
        return self[index]
      }).reduce(Element.zero, +)
    }
    
    if columnRange.isEmpty {
      return .zero
    } else if columnRange.count == 1 {
      let column = columnRange.first!
      let index = Index(row: row, column: column)
      return self[index]
    } else if columnRange == (0 ..< (row + 1)) {
      // TODO: How to ensure this goes to the specialized version, if available?
      return self.sumOfElements(in: row)
    } else if row < 4 {
      // If there are four or fewer columns (row index less than four), then all
      // columns are considered exterior and can be computed in constant-time.
      let indexes = (0...row).filter({
        columnRange.contains($0)
      })
      return sumOfElements(at: indexes)
    } else {
      // Elements in the interior are more expensive to compute than those on
      // the ends, so check to see if the range of columns extends to both ends.
      let interiorRange = 2 ..< (row - 2)
      let columnRangeIsOnlyInInterior = interiorRange.contains(columnRange)
      
      if columnRangeIsOnlyInInterior {
        // TODO: For performance, if this range crosses the mid point, get the
        // symmetrical values, then adding any lop-sided values.
        return sumOfElements(at: columnRange)
      } else {
        // It’s faster to compute the sum of the full row (which is O(1)), then
        // subtract out the values on the ends that can also be computed in
        // O(1), than it is to compute each value separately and add them up.
        // TODO: How to ensure this goes to the specialized version, if available?
        let sum = self.sumOfElements(in: row)
        
        // <#comment#>
        let exteriorIndexes: [Int] = [0, 1, row - 1, row].filter({
          !columnRange.contains($0)
        })
        
        let exteriorValues = sumOfElements(at: exteriorIndexes)
        
        return (sum - exteriorValues)
      }
    }
  }
}

extension ArithmeticTriangle where Element: BinaryInteger {
  /// - Complexity: O(1)
  @inlinable
  public func sumOfElements(in row: Int) -> Element {
    // The sum of elements in an integer arithmetic triangle is 2^n.
    return (self.base << row)
  }
}

// MARK: - Sequence

extension ArithmeticTriangle: Sequence {
  /// The iterator for a `ArithmeticTriangle` instance. Iterates from
  /// left-to-right (column 0...n), then top-to-bottom (row 0...).
  public struct Iterator: IteratorProtocol {
    @usableFromInline
    internal var arithmeticTriangle: ArithmeticTriangle
    
    @usableFromInline
    internal var index: Index
    
    @inlinable
    public mutating func next() -> Element? {
      index = index.next()
      return arithmeticTriangle[index]
    }
    
    internal init(_ arithmeticTriangle: ArithmeticTriangle) {
      self.arithmeticTriangle = arithmeticTriangle
      self.index = Index(row: 0, column: 0)
    }
  }
  
  public func makeIterator() -> Iterator {
    Iterator(self)
  }
}

// MARK: - Collection

extension ArithmeticTriangle: Collection {
  public struct Index: Comparable, Hashable {
    /// The index of the row in the arithmetic triangle, starting at 0.
    /// - Note: The value must be non-negative.
    @usableFromInline
    internal let row: Int
    
    /// The index of the column in the arithmetic triangle, starting at 0.
    /// - Note: The value must be non-negative and less than or equal to `row`.
    @usableFromInline
    internal let column: Int
    
    @usableFromInline
    internal init(row: Int, column: Int) {
      assert(row >= 0, "A row must have a non-negative index.")
      assert(column >= 0, "A column must have a non-negative index.")
      assert(column <= row, "Column \(column) does not exist in row \(row).")
      self.row = row
      self.column = column
    }
    
    /// An arithmetical triangle index is considered less than another index if
    /// its row is less than the other index’s row, or if they both are in the
    /// same row, if the column is less than the other index’s column.
    @inlinable
    public static func < (lhs: Index, rhs: Index) -> Bool {
      if lhs.row < rhs.row {
        return true
      } else if lhs.row > rhs.row {
        return false
      } else {
        return (lhs.column < rhs.column)
      }
    }
    
    /// Returns the indexes of the two values to add to get the value at the
    /// receiving index in an arithmetic triangle.
    @inlinable
    internal func indexesForSum() -> (Index, Index) {
      return (
        Index(row: row - 1, column: column),
        Index(row: row - 1, column: column - 1)
      )
    }
    
    /// Returns the arithmetical triangle index after the receiving index
    /// (incrementing the column by 1, wrapping to the next row if necessary).
    @inlinable
    public func next() -> Index {
      // If the index is not at the end of the row (the maximum column index in
      // a row is less than or equal to row’s index), increment the column.
      // Otherwise, increment the row and reset the column to 0.
      if column < row {
        return Index(row: row, column: column + 1)
      } else {
        return Index(row: row + 1, column: 0)
      }
    }
    
    /// Returns whether or not the index’s column is the first or last column
    /// in its row.
    @inlinable
    internal func isColumnFirstOrLast() -> Bool {
      return (column == 0 || column == row)
    }
  }
  
  @inlinable
  public var startIndex: Index {
    return Index(row: 0, column: 0)
  }
  
  @inlinable
  public var endIndex: Index {
    // While the arithmetical triangle is theoretically infinite, it’s
    // technically bound to the maximum integer that can be represented.
    return Index(row: .max, column: .max)
  }
  
  @inlinable
  public subscript(i: Index) -> Element {
    get {
      guard i.row >= 0 else { return .zero }
      
      switch i.column {
        case 0, i.row:
          // The first and last columns are always equal to the base.
          return base
          
        case ..<0, (i.row + 1)...:
          // Elements outside the triangle are considered to be 0.
          return .zero
          
        case (i.row / 2 + 1)...:
          // The triangle is symmetric horizontally (across columns).
          let symmetricIndex = Index(row: i.row, column: i.row - i.column)
          return self[symmetricIndex]
          
        default:
          if let value = cache[i] {
            return value
          } else {
            let (lhs, rhs) = i.indexesForSum()
            let sum = (self[lhs] + self[rhs])
//            cache[i] = sum
            return sum
          }
      }
    }
  }
  
  @inlinable
  public subscript(row: Int, column: Int) -> Element {
    let index = Index(row: row, column: column)
    return self[index]
  }
  
  @inlinable
  public func index(after i: Index) -> Index {
    return i.next()
  }
  
  /*
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    guard n != 0 else { return i }
    
    // TODO: Handle negatives
    // TODO: Performance
    var index = i
    for _ in 0..<n {
      index = index.next()
    }
  }

  @inlinable
  public func index(
    _ i: Index,
    offsetBy n: Int,
    limitedBy limit: Index
  ) -> Index? {
    if n == 0 { return i }
    return n > 0
      ? offsetForward(i, by: n, limitedBy: limit)
      : offsetBackward(i, by: -n, limitedBy: limit)
  }
  
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    
  }
 */
}
