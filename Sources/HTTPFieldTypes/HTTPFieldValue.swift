//
//  HTTPFieldValue.swift
//
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation
import HTTPTypes

/// A namespace for all HTTP field values.
//public enum HTTPFieldValues {}

/// A protocol for any type that can be represented as the `String` value of an HTTP header field.
public protocol HTTPFieldContent: Hashable, Sendable, CustomStringConvertible {
    /// The value in string form, for use in a header field.
    var fieldValue: String { get }
    /// Initializes the value from a header field's string value.
    init?(_ fieldValue: String)
}

extension HTTPFieldContent {
    public var description: String { fieldValue }
}

extension HTTPFieldContent where Self: RawRepresentable, RawValue == String {
    public var fieldValue: String { rawValue }
    public init?(_ fieldValue: String) {
        self.init(rawValue: fieldValue)
    }
}

/// An extension on ``HTTPFieldContent`` for types that are used in the context a specific header field.
public protocol HTTPFieldValue: HTTPFieldContent {
    /// The field name associated with this value type.
    static var fieldName: HTTPField.Name { get }
}

internal extension HTTPFields {
    subscript<F: HTTPFieldValue>(fieldType: F.Type) -> F? {
        get {
            self[F.fieldName].flatMap(F.init)
        } set {
            self[F.fieldName] = newValue?.fieldValue
        }
    }
}
