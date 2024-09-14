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
///
/// > Important: Because all instances of conforming types are intended for use in the context of HTTP headers as strings, all equality checks of conforming types will use their `String` form (``fieldContent-2nxzz``).
public protocol HTTPFieldContent: Hashable, Sendable, CustomStringConvertible {
    /// The value in string form, for use in a header field.
    var fieldContent: String { get }
    /// Initializes the value from a header field's string value.
    init?(_ fieldContent: String)
}

extension HTTPFieldContent {
    public var description: String { fieldContent }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.fieldContent == rhs.fieldContent
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(fieldContent)
    }
}

extension HTTPFieldContent where Self: RawRepresentable, RawValue == String {
    public var fieldContent: String { rawValue }
    public init?(_ fieldContent: String) {
        self.init(rawValue: fieldContent)
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
            self[F.fieldName] = newValue?.fieldContent
        }
    }
}
