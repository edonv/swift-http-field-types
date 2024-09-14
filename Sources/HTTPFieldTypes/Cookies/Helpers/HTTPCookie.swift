//
//  HTTPCookie.swift
//  
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation

/// A type for representing a cookie definition in the context of HTTP header fields.
///
/// Cookies are used in ``HTTPCookieField`` and ``HTTPSetCookieField`` fields.
///
/// ## Syntax
///
/// Used in a `"Date"` header:
/// ```
/// <cookie-name>=<cookie-value>
/// ```
///
/// > Note: Some `<cookie-name>` have a specific semantic:
/// >
/// > `__Secure-` **prefix**: Cookies with names starting with `__Secure-` (dash is part of the prefix) must be set with the `secure` flag from a secure page (HTTPS).
/// >
/// > `__Host-` **prefix**: Cookies with names starting with `__Host-` are sent only to the host subdomain or domain that set them, and not to any other host. They must be set with the `secure` flag, must be from a secure page (HTTPS), must not have a domain specified, and the path must be `/`.
public struct HTTPCookie: HTTPFieldContent {
    private static let allowedCharacters: CharacterSet = .controlCharacters
        .union(.whitespacesAndNewlines)
        .union(CharacterSet(charactersIn: "()<>@,;:\\\"/[]?={}"))
        .inverted
    
    /// The name of the cookie.
    ///
    /// > Important: A `<cookie-name>` can contain any US-ASCII characters except for: control characters (ASCII characters 0 up to 31 and ASCII character 127) or separator characters (space, tab and the characters: `( ) < > @ , ; : \ " / [ ] ? = { }`).
    public let name: String
    
    /// The name of the cookie.
    ///
    /// > Important: A `<cookie-value>` can optionally be wrapped in double quotes and include any US-ASCII character excluding control characters (ASCII characters 0 up to 31 and ASCII character 127), Whitespace, double quotes, commas, semicolons, and backslashes.
    /// >
    /// > If any of these characters are present, they're percent encoded. [See here for more.](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#cookie-namecookie-value)
    public let value: String
    
    private var _value: String {
        value
            .addingPercentEncoding(withAllowedCharacters: HTTPCookie.allowedCharacters)!
    }
    
    public init(name: String, value: String) {
        self.name = name
        self.value = (value.removingPercentEncoding ?? value)
            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
    }
    
    public var fieldContent: String {
        "\(name)=\(_value)"
    }
    
    public init?(_ fieldContent: String) {
        let split = fieldContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "=")
        
        guard split.count == 2 else { return nil }
        
        self.init(name: split[0], value: split[1])
    }
}
