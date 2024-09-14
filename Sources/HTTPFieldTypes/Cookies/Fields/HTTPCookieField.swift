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
    
    private var _cookies: [String: String]
    public var cookies: Set<Cookie> {
        Set(_cookies.map { Cookie(name: $0.key, value: $0.value) })
    }
    
    public init(_ cookies: [Cookie]) {
        self._cookies = cookies.reduce(into: [:]) { partial, cookie in
            partial[cookie.name] = cookie.value
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
        
        let cookies: [Cookie] = elements.reduce(into: []) { partial, cookie in
            guard let c = Cookie(cookie) else { return }
            partial.append(c)
        }
        
        guard cookies.count == elements.count else { return nil }
        self.init(cookies)
    }
    
    public mutating func set(cookie name: String, to value: String?) {
        self[name] = value
            .map { Cookie(name: name, value: $0) }
    }
    
    public subscript(name: String) -> Cookie? {
        get {
            self._cookies[name]
                .map { Cookie(name: name, value: $0) }
        } set {
            if newValue?.name != name {
                self._cookies.removeValue(forKey: name)
            }
            
            self._cookies[name] = newValue?.value
        }
    }
    
    public subscript(valueFor name: String) -> String? {
        get {
            self._cookies[name]
        } set {
            self._cookies[name] = newValue
        }
    }
}
