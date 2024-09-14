//
//  HTTPRange.swift
//
//
//  Created by Edon Valdman on 7/23/24.
//

import Foundation

/// A range value used in ``HTTPRangeField`` and ``HTTPContentRangeField`` fields.
///
/// It has 3 possible forms:
///   1. a `ClosedRange`,
///   2. a `PartialRangeFrom`,
///   3. or a "reverse index", where it specifies the index from the end.
public enum HTTPRange: RawRepresentable, HTTPFieldContent {
    /// A `ClosedRange`.
    case closed(ClosedRange<Int>)
    
    /// A `PartialRangeFrom`.
    case partialFrom(PartialRangeFrom<Int>)
    
    /// A `PartialRangeFrom` where `index` is the index counted from the end.
    ///
    /// > Important: It's works like a zeroed index. So if the range value is `-499` (`index` == `499`) and the total length is `1000` (which means the last valid index is `999`), this range equates to the last `500` elements.
    case fromEnd(_ index: Int)
    
    public init(_ range: ClosedRange<Int>) {
        self = .closed(range)
    }
    
    public init(_ range: PartialRangeFrom<Int>) {
        self = .partialFrom(range)
    }
    
    /// Initialize from a raw string representation from a header field.
    public init?(rawValue: String) {
        let cleaned = rawValue
            .components(separatedBy: "=").last!
            .components(separatedBy: ", ").first!
        
        let split = cleaned
            .split(separator: "-")
        
        if split.count == 2,
           let lower = Int(split[0]),
           let upper = Int(split[1]) {
            self = .closed(lower...upper)
        } else {
            if cleaned.first == "-",
               let value = Int(cleaned.dropFirst()) {
                self = .fromEnd(value)
            } else if cleaned.last == "-",
                      let value = Int(cleaned.dropLast()) {
                self = .partialFrom(value...)
            } else {
                return nil
            }
        }
    }
    
    /// The raw string representation for insertion in a header field.
    public var rawValue: String {
        switch self {
        case .closed(let closedRange):
            return "\(closedRange.lowerBound)-\(closedRange.upperBound)"
        case .partialFrom(let partialRangeFrom):
            return "\(partialRangeFrom.lowerBound)-"
        case .fromEnd(let index):
            return "-\(index)"
        }
    }
}

extension HTTPRange: RangeExpression {
    public typealias Bound = Int
    
    public func relative<C>(
        to collection: C
    ) -> Swift.Range<Int> where C: Collection, Int == C.Index {
        switch self {
        case .closed(let closedRange):
            return closedRange.relative(to: collection)
        case .partialFrom(let partialRangeFrom):
            return partialRangeFrom.relative(to: collection)
        case .fromEnd(let index):
            let startIndex = collection.index(collection.endIndex, offsetBy: -(index + 1))
            let partialRange = startIndex...
            return partialRange.relative(to: collection)
        }
    }
    
    public func contains(_ element: Int) -> Bool {
        switch self {
        case .closed(let closedRange):
            return closedRange.contains(element)
        case .partialFrom(let partialRangeFrom):
            return partialRangeFrom.contains(element)
        case .fromEnd(let index):
            return (-index...0).contains(-index)
        }
    }
}

extension HTTPRange: CustomStringConvertible {
    public var description: String { rawValue }
}

//extension Collection {
////    public subscript(r: HTTPRangeField.Range) -> Self.SubSequence {
////        // TODO: TEST
////        // Given a resource with a length of 10000 bytes, the following example requests three separate ranges; 200-999 (800 bytes), 2000-2499 (500 bytes), and finally 9500-. The ranges-specifier value 9500- omits an end position which indicates that all bytes from 9500 onward are part of the third range (500 bytes).
////        switch r {
////        case .closed(let closedRange):
////            let startIndex = self.index(self.startIndex, offsetBy: closedRange.lowerBound)
////            let endIndex = self.index(self.startIndex, offsetBy: closedRange.upperBound)
////            return self[startIndex...endIndex]
////        case .partialFrom(let partialRangeFrom):
////            let startIndex = self.index(self.startIndex, offsetBy: partialRangeFrom.lowerBound)
////            return self[startIndex...]
////        case .fromEnd(let index):
////            let startIndex = self.index(self.endIndex, offsetBy: -(index + 1))
////            return self[startIndex...]
////        }
////    }
//}
