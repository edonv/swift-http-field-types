//
//  HTTPFieldCookieTests.swift
//  
//
//  Created by Edon Valdman on 9/14/24.
//

import XCTest
import HTTPTypes
import HTTPFieldTypes

final class HTTPFieldCookieTests: XCTestCase {

    func testExample() throws {
        let date = Date.now
        let httpDate = HTTPDate(date)
        let str = httpDate.fieldContent
        print("HTTPDate from date:", httpDate)
        print("fieldContent:", str)
        let httpDate2 = HTTPDate(str)
        print("HTTPDate from string:", httpDate2 as Any)
    }
}
