//
//  HTTPRange+Unit.swift
//
//
//  Created by Edon Valdman on 7/23/24.
//

import Foundation

extension HTTPRange {
    /// The unit in which ranges are specified.
    ///
    /// Currently only `bytes` units are registered which are *offsets* (zero-indexed & inclusive). If the requested data has a content coding applied, each byte range represents the encoded sequence of bytes, not the bytes that would be obtained after decoding.
    ///
    /// See [here](https://www.rfc-editor.org/rfc/rfc9110.html#section-14.1) for more info.
    public enum Unit: Hashable, Sendable, RawRepresentable {
        case bytes
        case other(String)
        
        /// A value used in an `"Accept-Ranges"` header to indicate that a `"Range"` header is not supported by the endpoint.
        ///
        /// Indicates that no range unit is supported. This makes the header equivalent of its own absence and is therefore, rarely used. Although in some browsers, like IE9, this setting is used to disable or remove the pause buttons in the download manager.
        public static var none: Unit? { nil }
        
        /// Initialize from a raw string representation from a header field.
        public init(rawValue: String) {
            switch rawValue.lowercased() {
            case "bytes": self = .bytes
            default: self = .other(rawValue)
            }
        }
        
        /// The value rendered for insertion in a header field.
        public var rawValue: String {
            switch self {
            case .bytes: return "bytes"
            case .other(let string): return string
            }
        }
    }
}

extension HTTPRange.Unit: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension HTTPRange.Unit: CustomStringConvertible {
    public var description: String { rawValue }
}
