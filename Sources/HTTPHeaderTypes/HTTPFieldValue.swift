//
//  HTTPFieldValue.swift
//
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation
import HTTPTypes

/// A protocol for any type that refers to the value of specific header field(s).
public protocol HTTPFieldValue: Hashable, Sendable, RawRepresentable, ExpressibleByStringLiteral, CustomStringConvertible {
    /// The field name associated with this value type.
    static var fieldName: HTTPField.Name { get }
    
    /// The value in string form, for use in a header field.
    var stringValue: String { get }
    /// Initializes the value from a header field's string value.
    init(_ stringValue: String)
}

extension HTTPFieldValue {
    public var rawValue: String { stringValue }
    public init(rawValue: String) {
        self.init(rawValue)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public var description: String { stringValue }
}
