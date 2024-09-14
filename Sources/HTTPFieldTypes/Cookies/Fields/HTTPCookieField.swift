//
//  HTTPCookieField.swift
//
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation
import HTTPTypes

/// The value of a `Cookie` HTTP header field.
///
/// A `Cookie` header may contain more than one ``HTTPCookie``, but each must have a unique ``HTTPCookie/name``.
///
/// The `Cookie` HTTP request header contains stored [HTTP cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies) associated with the server (i.e. previously sent by the server with the ``HTTPSetCookieField`` field).
///
/// The `Cookie` header is optional and may be omitted if, for example, the browser's privacy settings block cookies.
///
/// [See here for more.](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies)
public struct HTTPCookieField: HTTPFieldValue {
    public typealias Cookie = HTTPCookie
    
    public static let fieldName: HTTPField.Name = .cookie
    
    public let cookies: Set<Cookie>
    
    public init(_ cookies: [Cookie]) {
        self.cookies = cookies.reduce(into: []) { partial, cookie in
            guard !partial.contains(where: { $0.name == cookie.name }) else { return }
            partial.insert(cookie)
        }
    }
    
    public var fieldContent: String {
        return self.cookies
            .map(\.fieldContent)
            .joined(separator: "; ")
    }
    
    public init?(_ fieldContent: String) {
        let elements = fieldContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "; ")
        
        self.cookies = elements.reduce(into: []) { partial, cookie in
            guard let c = Cookie(cookie) else { return }
            partial.insert(c)
        }
        
        guard self.cookies.count == elements.count else { return nil }
    }
}
