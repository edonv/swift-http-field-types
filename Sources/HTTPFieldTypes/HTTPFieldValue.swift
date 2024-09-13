//
//  HTTPFieldValue.swift
//
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation
import HTTPTypes

/// A protocol for any type that refers to the value of specific header field(s).
public protocol HTTPFieldValue: Hashable, Sendable, RawRepresentable, CustomStringConvertible {
    /// The field name associated with this value type.
    static var fieldName: HTTPField.Name { get }
    
    /// The value in string form, for use in a header field.
    var fieldValue: String { get }
    /// Initializes the value from a header field's string value.
    init?(_ fieldValue: String)
}

extension HTTPFieldValue {
    public var rawValue: String { fieldValue }
    public init?(rawValue: String) {
        self.init(rawValue)
    }
    
    public var description: String { fieldValue }
}
