//
//  HTTPDate.swift
//
//
//  Created by Edon Valdman on 9/13/24.
//

import Foundation
import HTTPTypes

/// A type for representing dates in the context of HTTP header fields.
///
/// While primarily used by `"Date"` headers, its formatting is used in the context of other fields as well.
///
/// > Important: When using `HTTPDate` in a header field, units smaller than a `second` won't be included. Therefore, comparisons of instances of this type will not take into account such units.
///
/// ## Syntax
///
/// Used in a `"Date"` header:
/// ```
/// Date: <day-name>, <day> <month> <year> <hour>:<minute>:<second> GMT
/// Date: Wed, 21 Oct 2015 07:28:00 GMT
/// ```
public struct HTTPDate: HTTPFieldValue {
    public static let fieldName: HTTPField.Name = .date
    
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        
        f.formattingContext = .standalone
        f.timeZone = .init(secondsFromGMT: 0)
        f.calendar = .init(identifier: .gregorian)
        
        f.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        
        return f
    }()
    
    /// The underlying `Date`.
    public let date: Date
    
    public init(_ date: Date) {
        self.date = date
    }
    
    public var fieldContent: String {
        HTTPDate.formatter.string(from: self.date)
    }
    
    public init?(_ fieldContent: String) {
        guard let date = HTTPDate.formatter.date(from: fieldContent) else { return nil }
        self.date = date
    }
}
