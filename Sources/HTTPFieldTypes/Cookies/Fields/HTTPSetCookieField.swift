//
//  HTTPSetCookieField.swift
//
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation
import HTTPTypes

/// The value of a `Set-Cookie` HTTP header field.
///
/// A `Set-Cookie` header may contain more than one ``HTTPSetCookieField/Attribute``, but must not contain more than one of the same kind.
///
/// The `Set-Cookie` HTTP response header is used to send a cookie from the server to the user agent, so that the user agent can send it back to the server later. To send multiple cookies, multiple `Set-Cookie` headers should be sent in the same response.
///
/// [See here for more.](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie)
public struct HTTPSetCookieField: HTTPFieldValue {
    public typealias Cookie = HTTPCookie
    
    public static let fieldName: HTTPField.Name = .setCookie
    
    /// The cookie set by this header field.
    public let cookie: Cookie
    
    private var _attributes: [Attribute.Name: Attribute]
    /// The attribute(s) specified by this header field.
    ///
    /// [See here for more.](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#attributes)
    public var attributes: Set<Attribute> {
        Set(_attributes.values)
    }
    
    public init(_ cookie: Cookie, attributes: Set<Attribute> = []) {
        self.cookie = cookie
        self._attributes = attributes.reduce(into: [:]) { partial, attr in
            partial[attr.name] = attr
        }
    }
    
    public var fieldContent: String {
        (
            CollectionOfOne(cookie.fieldContent)
            + Array(attributes.map(\.fieldContent))
        )
        .joined(separator: "; ")
    }
    
    public init?(_ fieldContent: String) {
        let elements = fieldContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "; ")
        
        guard let cookieStr = elements.first,
              let cookie = Cookie(cookieStr) else { return nil }
        
        let remainingEls = elements
            .dropFirst()
        
        let attributes: Set<Attribute> = remainingEls.reduce(into: []) { partial, attrString in
            guard let attr = Attribute(attrString) else { return }
            partial.insert(attr)
        }
        
        // Ensure finished with same number attributes as split string elements
        guard attributes.count == remainingEls.count
                // If contains .partitioned, must contain .secure
                && !(attributes.contains(.partitioned) && !attributes.contains(.secure))
                // If contains .sameSite(.none), must contain .secure
                && !(attributes.contains(.sameSite(.none)) && !attributes.contains(.secure)) else {
            return nil
        }
        self.init(cookie, attributes: attributes)
    }
}
