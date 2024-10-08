//
//  HTTPRangeField.swift
//
//
//  Created by Edon Valdman on 7/21/24.
//

import Foundation
import HTTPTypes

/// The value of a `Range` HTTP header field.
///
/// It notes the units that ``ranges`` is measured in, then lists range(s).
///
/// See [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Range) for more detail.
public struct HTTPRangeField: HTTPFieldValue {
    public static let fieldName: HTTPField.Name = .range
    
    /// The unit that ``ranges`` is measured in.
    public let unit: HTTPRange.Unit
    /// The field's range(s).
    public let ranges: [HTTPRange]
    
    public init(unit: HTTPRange.Unit, ranges: [HTTPRange]) {
        self.unit = unit
        self.ranges = ranges
    }
    
    public var fieldContent: String {
        return "\(unit.fieldContent)=\(ranges.map(\.fieldContent).joined(separator: ", "))"
    }
    
    public init?(_ fieldContent: String) {
        let split = fieldContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(maxSplits: 2, whereSeparator: { $0 == "=" })
        
        // 0-50, 100-150
        let ranges: [HTTPRange] = split[1]
            .components(separatedBy: ", ")
            .compactMap { exp in
                return .init(exp)
            }
        
        self = .init(unit: .init(String(split[0])), ranges: ranges)
    }
}
