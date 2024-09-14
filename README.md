# Swift HTTP Field Types

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2Fswift-http-field-types%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/edonv/swift-http-field-types)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2Fswift-http-field-types%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/edonv/swift-http-field-types)

Formerly `swift-http-ranges`, `swift-http-field-types` now covers all kinds of special value types found in HTTP header fields. It builds on Apple's [`swift-http-types`](https://github.com/apple/swift-http-types).

## Supported Headers

- Ranges
  - [Range](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Range)
  - [Content-Range](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Range)
- Cookies
  - [Cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cookie)
  - [Set-Cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie)
- Dates
  - [Date](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date) (Note that this field type isn't fully finished yet, only the value type of the header is complete.)
