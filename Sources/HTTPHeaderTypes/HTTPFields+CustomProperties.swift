//
//  HTTPFields+CustomProperties.swift
//
//
//  Created by Edon Valdman on 7/23/24.
//

import Foundation
import HTTPTypes

extension HTTPFields {
    /// If there is a `"Range"` header field, convert it to a ``HTTPRangeField``.
    ///
    /// See <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Range#syntax> for more detail.
    public var range: HTTPRangeField? {
        get {
            return self[.range].flatMap { .init(rawValue: $0) }
        } set {
            self[.range] = newValue?.rawValue
        }
    }
    
    /// If there is a `"Accept-Ranges"` header field, convert it to a ``HTTPRange/Unit``.
    ///
    /// See <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Ranges> for more detail.
    public var acceptRanges: HTTPRange.Unit? {
        get {
            return self[.acceptRanges]
                .flatMap { field in
                    guard field != "none" else { return nil }
                    return .init(rawValue: field)
                }
        } set {
            self[.acceptRanges] = newValue != .other("none") ? newValue?.rawValue : nil
        }
    }
    
    /// If there is a `"Content-Range"` header field, convert it to a ``HTTPContentRangeField``.
    ///
    /// See <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Range> for more detail.
    public var contentRange: HTTPContentRangeField? {
        get {
            return self[.contentRange].flatMap { .init(rawValue: $0) }
        } set {
            self[.contentRange] = newValue?.rawValue
        }
    }
}

