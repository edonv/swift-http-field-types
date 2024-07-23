import XCTest
import HTTPTypes
@testable import HTTPRanges

final class HTTPFieldRangeTests: XCTestCase {
    // MARK: - HTTPRange
    
    func testRangeSubscripts() throws {
        let values = Array(0...10)
        let ranges: [HTTPRange] = [
            .closed(0...4),
            .partialFrom(5...),
            .fromEnd(4),
        ]
        
        XCTAssert(values[ranges[0]] == values[0...4])
        XCTAssert(values[ranges[1]] == values[5...])
        XCTAssert(values[ranges[2]] == values[(values.count - 4 - 1)...])
    }
    
    // MARK: - HTTPRangeField
    
    func testDecodeRange() throws {
        let string = "bytes=200-999, 2000-2499, 9500-, -500"
        let range = HTTPRangeField(rawValue: string)
        print(range ?? "")
        XCTAssert(
            range == .init(
                unit: .bytes,
                ranges: [
                    .closed(200...999),
                    .closed(2000...2499),
                    .partialFrom(9500...),
                    .fromEnd(500),
                ]
            )
        )
    }
    
    func testEncodeRange() throws {
        let field = HTTPRangeField(
            unit: .bytes,
            ranges: [
                .closed(200...999),
                .closed(2000...2499),
                .partialFrom(9500...),
                .fromEnd(500),
            ]
        )
        
        print(field.rawValue)
        XCTAssert(field.rawValue == "bytes=200-999, 2000-2499, 9500-, -500")
    }
    
    // MARK: - HTTPContentRangeField
    
    func testDecodeContentRange() {
        let string1 = "bytes 200-1000/67589"
        let range1 = HTTPContentRangeField(rawValue: string1)
//        print(range ?? "")
        XCTAssert(
            range1 == .init(
                unit: .bytes,
                range: 200...1000,
                totalSize: 67589
            )
        )
        
        let string2 = "test 200-1000/*"
        let range2 = HTTPContentRangeField(rawValue: string2)
        //        print(range ?? "")
        XCTAssert(
            range2 == .init(
                unit: "test",
                range: 200...1000,
                totalSize: .unknown
            )
        )
        
        let string3 = "test */67589"
        let range3 = HTTPContentRangeField(rawValue: string3)
        //        print(range ?? "")
        XCTAssert(
            range3 == .init(
                unit: "test",
                range: nil,
                totalSize: 67589
            )
        )
    }
    
    func testEncodeContentRange() throws {
        let range1 = HTTPContentRangeField(
            unit: .bytes,
            range: 200...1000,
            totalSize: 67589
        )
        
        XCTAssert(range1.rawValue == "bytes 200-1000/67589")
        
        let range2 = HTTPContentRangeField(
            unit: "test",
            range: 200...1000,
            totalSize: .unknown
        )
        XCTAssert(range2.rawValue == "test 200-1000/*")
        
        let range3 = HTTPContentRangeField(
            unit: "test",
            range: nil,
            totalSize: 67589
        )
        XCTAssert(range3.rawValue == "test */67589")
    }

}
