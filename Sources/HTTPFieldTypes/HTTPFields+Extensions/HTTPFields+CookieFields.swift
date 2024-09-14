//
//  HTTPFields+CookieFields.swift
//  
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation
import HTTPTypes

extension HTTPFields {
    /// If there is a `"Cookie"` header field, convert it to a ``HTTPCookieField``.
    ///
    /// See <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cookie> for more detail.
    public var cookie: HTTPCookieField? {
        get {
            self[HTTPCookieField.self]
        } set {
            self[HTTPCookieField.self] = newValue
        }
    }
    
    /// If there are any `"Set-Cookie"` header fields, convert each to a ``HTTPSetCookieField``.
    ///
    /// See <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie> for more detail.
    public var setCookies: [HTTPSetCookieField] {
        get {
            self[values: HTTPSetCookieField.fieldName]
                .compactMap(HTTPSetCookieField.init)
        } set {
            self[values: HTTPSetCookieField.fieldName] = newValue
                .map(\.fieldContent)
        }
    }
}

