//
//  HTTPSetCookie+Attributes.swift
//
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation

extension HTTPSetCookieField {
    /// A type representing additional specifications for a specific ``HTTPCookie`` in a ``HTTPSetCookieField``.
    ///
    /// Multiple `Attribute`s can be used for each `HTTPSetCookieField`.
    ///
    /// [See here for more.](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie)
    public enum Attribute: RawRepresentable, HTTPFieldContent {
        /// `Domain=<domain-value>`
        ///
        /// Defines the host to which the cookie will be sent.
        ///
        /// Only the current domain can be set as the value, or a domain of a higher order, unless it is a public suffix. Setting the domain will make the cookie available to it, as well as to all its subdomains.
        ///
        /// If omitted, this attribute defaults to the host of the current document URL, not including subdomains.
        ///
        /// Contrary to earlier specifications, leading dots in domain names (`.example.com`) are ignored.
        ///
        /// Multiple host/domain values are *not* allowed, but if a domain is specified, then subdomains are always included.
        case domain(String)
        
        /// `Expires=<date>`
        ///
        /// Indicates the maximum lifetime of the cookie as an HTTP-date timestamp.
        ///
        /// If unspecified, the cookie becomes a **session cookie**. A session finishes when the client shuts down, after which the session cookie is removed.
        ///
        /// > Warning: Many web browsers have a *session restore* feature that will save all tabs and restore them the next time the browser is used. Session cookies will also be restored, as if the browser was never closed.
        ///
        /// When an `Expires` date is set, the deadline is relative to the *client* the cookie is being set on, not the server.
        case expires(HTTPDate)

        /// `HttpOnly`
        ///
        /// Forbids JavaScript from accessing the cookie, for example, through the [`Document.cookie`](https://developer.mozilla.org/en-US/docs/Web/API/Document/cookie) property. Note that a cookie that has been created with `HttpOnly` will still be sent with JavaScript-initiated requests, for example, when calling [`XMLHttpRequest.send()`](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/send) or [`fetch()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/fetch). This mitigates attacks against cross-site scripting ([XSS](https://developer.mozilla.org/en-US/docs/Glossary/Cross-site_scripting)).
        case httpOnly
        
        /// `Max-Age=<number>`
        ///
        /// Indicates the number of seconds until the cookie expires. A zero or negative number will expire the cookie immediately. If both `Expires` and `Max-Age` are set, `Max-Age` has precedence.
        case maxAge(Int)
        
        /// `Partitioned`
        ///
        /// Indicates that the cookie should be stored using partitioned storage. Note that if this is set, the [`Secure` directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#secure) must also be set. See [Cookies Having Independent Partitioned State (CHIPS)](https://developer.mozilla.org/en-US/docs/Web/Privacy/Privacy_sandbox/Partitioned_cookies) for more details.
        case partitioned
        
        /// `Path=<path-value>`
        ///
        /// Indicates the path that must exist in the requested URL for the browser to send the ``HTTPCookieField`` header.
        ///
        /// The forward slash (`/`) character is interpreted as a directory separator, and subdirectories are matched as well. For example, for `Path=/docs`,
        /// - the request paths `/docs`, `/docs/`, `/docs/Web/`, and `/docs/Web/HTTP` will all match.
        /// - the request paths `/`, `/docsets`, `/fr/docs` will not match.
        case path(String)
        
        /// `Secure`
        ///
        /// Indicates that the cookie is sent to the server only when a request is made with the `https:` scheme (except on localhost), and therefore, is more resistant to [man-in-the-middle](https://developer.mozilla.org/en-US/docs/Glossary/MitM) attacks.
        ///
        /// > Note: Do not assume that `Secure` prevents all access to sensitive information in cookies (session keys, login details, etc.). Cookies with this attribute can still be read/modified either with access to the client's hard disk or from JavaScript if the `HttpOnly` cookie attribute is not set.
        /// >
        /// > Insecure sites (`http:`) cannot set cookies with the `Secure` attribute (since Chrome 52 and Firefox 52). The `https:` requirements are ignored when the `Secure` attribute is set by localhost (since Chrome 89 and Firefox 75).
        case secure
        
        /// `SameSite=Strict`, `SameSite=Lax`, `SameSite=None; Secure`
        ///
        /// Controls whether or not a cookie is sent with cross-site requests, providing some protection against cross-site request forgery attacks ([CSRF](https://developer.mozilla.org/en-US/docs/Glossary/CSRF)).
        case sameSite(SameSiteValue)
        
        public var rawValue: String {
            let key = self.name.rawValue
            
            switch self {
            case .domain(let domain):
                return "\(key)=\(domain)"
            case .expires(let date):
                return "\(key)=\(date.fieldContent)"
            case .maxAge(let int):
                return "\(key)=\(int)"
            case .path(let path):
                return "\(key)=\(path)"
            case .sameSite(let value):
                return "\(key)=\(value.fieldContent)"
                
            default:
                return key
            }
        }
        
        public init?(rawValue: String) {
            let split = rawValue
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "=")
            
            guard let keyStr = split.first,
                  let key = Name(rawValue: keyStr),
                  split.count == key.splitStrElCount else { return nil }
            
            switch key {
            case .domain:
                self = .domain(split[1])
            case .expires:
                guard let date = HTTPDate(split[1]) else { return nil }
                self = .expires(date)
            case .httpOnly:
                self = .httpOnly
            case .maxAge:
                guard let int = Int(split[1]) else { return nil }
                self = .maxAge(int)
            case .partitioned:
                self = .partitioned
            case .path:
                self = .path(split[1])
            case .secure:
                self = .secure
            case .sameSite:
                guard let v = SameSiteValue(split[1]) else { return nil }
                self = .sameSite(v)
            }
        }
        
        public enum SameSiteValue: String, HTTPFieldContent {
            /// Means that the browser sends the cookie only for same-site requests, that is, requests originating from the same site that set the cookie. If a request originates from a different domain or scheme (even with the same domain), no cookies with the `SameSite=Strict` attribute are sent.
            case strict = "Strict"
            
            /// Means that the cookie is not sent on cross-site requests, such as on requests to load images or frames, but is sent when a user is navigating to the origin site from an external site (for example, when following a link). This is the default behavior if the `SameSite` attribute is not specified.
            case lax = "Lax"
            
            /// Means that the browser sends the cookie with both cross-site and same-site requests. The ``Attribute/secure`` attribute must also be set when setting this value, like so `SameSite=None; Secure`. If `Secure` is missing an error will be logged:
            ///
            /// ```
            /// Cookie "myCookie" rejected because it has the "SameSite=None" attribute but is missing the "secure" attribute.
            ///
            /// This Set-Cookie was blocked because it had the "SameSite=None" attribute but did not have the "Secure" attribute, which is required in order to use "SameSite=None".
            /// ```
            ///
            /// > Note: A [`Secure`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#secure) cookie is only sent to the server with an encrypted request over the HTTPS protocol. Note that insecure sites (`http:`) can't set cookies with the `Secure` directive, and therefore can't use `SameSite=None`.
            ///
            /// > Warning: Cookies with the `SameSite=None; Secure` that do not also have the ``Attribute/partitioned`` attribute may be blocked in cross-site contexts on future browser versions. This behavior protects user data from cross-site tracking. See [Cookies Having Independent Partitioned State (CHIPS)](https://developer.mozilla.org/en-US/docs/Web/Privacy/Privacy_sandbox/Partitioned_cookies) and [Third-party cookies](https://developer.mozilla.org/en-US/docs/Web/Privacy/Third-party_cookies).
            case none = "None"
        }
    }
}

extension HTTPSetCookieField.Attribute {
    internal var name: Name {
        switch self {
        case .domain: .domain
        case .expires: .expires
        case .httpOnly: .httpOnly
        case .maxAge: .maxAge
        case .partitioned: .partitioned
        case .path: .path
        case .secure: .secure
        case .sameSite: .sameSite
        }
    }
    
    internal enum Name: String {
        case domain = "Domain"
        case expires = "Expires"
        case httpOnly = "HttpOnly"
        case maxAge = "Max-Age"
        case partitioned = "Partitioned"
        case path = "Path"
        case secure = "Secure"
        case sameSite = "SameSite"
        
        var splitStrElCount: Int {
            hasAssociatedValue ? 2 : 1
        }
        
        private var hasAssociatedValue: Bool {
            switch self {
            case .domain, .expires, .maxAge, .path, .sameSite:
                return true
            default:
                return false
            }
        }
    }
}
