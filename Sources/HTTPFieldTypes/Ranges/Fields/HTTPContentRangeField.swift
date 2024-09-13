//
//  HTTPContentRangeField.swift
//  
//
//  Created by Edon Valdman on 7/23/24.
//

import Foundation
import HTTPTypes

/// The value of a `Content-Range` HTTP header.
///
/// It notes the units that ``range`` is measured in, a single range, then the total size. It indicates where in a full body message a partial message belongs.
///
/// See [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Range) for more detail.
public struct HTTPContentRangeField: HTTPFieldValue {
    public static let fieldName: HTTPField.Name = .contentRange
    
    /// The unit that ``range`` is measured in.
    public let unit: HTTPRange.Unit
    
    /// The range in a full body message that this field refers to.
    ///
    /// A `nil` value indicates an "unsatisfied range". This occurs in a `416` response message, indicating that the requested range was "unsatisfiable". This is noted in the header field as `*`. See [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/416) for more detail.
    public let range: ClosedRange<Int>?
    
    /// The total length of the document (or `*` if unknown).
    public let totalSize: Size
    
    public init(unit: HTTPRange.Unit, range: ClosedRange<Int>?, totalSize: Size) {
        self.unit = unit
        self.range = range
        self.totalSize = totalSize
    }
    
    public var fieldValue: String {
        let range = range.map { "\($0.lowerBound)-\($0.upperBound)" } ?? "*"
        return "\(unit.rawValue) \(range)/\(totalSize.rawValue)"
    }
    
    public init?(_ fieldValue: String) {
        let split = fieldValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(maxSplits: 2, whereSeparator: { $0 == " " })
        
        // It must have a range and size, and they can't both be *'s
        guard split.count == 2 && split != ["*", "*"] else { return nil }
        self.unit = .init(rawValue: String(split[0]))
        
        let rangePortion = split[1].components(separatedBy: "/")
        
        // The range must have 2 values
        guard rangePortion.count == 2,
              let size = Size(rawValue: rangePortion[1]) else { return nil }
        self.totalSize = size
        
        let rangeStr = rangePortion[0].components(separatedBy: "-")
        
        if rangeStr.count == 2,
           let lower = Int(rangeStr[0]),
           let upper = Int(rangeStr[1]) {
            self.range = lower...upper
        } else if rangeStr.count == 1
                    && rangeStr[0] == "*" {
            self.range = nil
        } else {
            return nil
        }
    }
    
    /// The total length of the message (or `*` if unknown).
    public enum Size: Hashable, Sendable, RawRepresentable, ExpressibleByIntegerLiteral {
        /// A known message size.
        case known(Int)
        
        /// An unknown message size (noted as `*` in a header field).
        case unknown
        
        public init(integerLiteral value: Int) {
            self = .known(value)
        }
        
        /// The raw string representation for insertion in a header field.
        public var rawValue: String {
            switch self {
            case .known(let int):
                return "\(int)"
            case .unknown:
                return "*"
            }
        }
        
        /// Initialize from a raw string representation from a header field.
        public init?(rawValue: String) {
            if let int = Int(rawValue) {
                self = .known(int)
            } else if rawValue == "*" {
                self = .unknown
            } else {
                return nil
            }
        }
    }
}

extension HTTPContentRangeField.Size: CustomStringConvertible {
    public var description: String { rawValue }
}
