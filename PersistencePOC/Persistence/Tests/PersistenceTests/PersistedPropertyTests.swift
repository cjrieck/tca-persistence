import Foundation
import XCTest
@testable import Persistence

final class PersistedPropertyTests: XCTestCase {
    func testEquality() {
        enum TestCodingKey: CodingKey {
            case one
            case two
        }

        let propertyOne = PersistedProperty(wrappedValue: 5, codingKeyName: TestCodingKey.one)
        let propertyTwo = PersistedProperty(wrappedValue: 10, codingKeyName: TestCodingKey.two)
        let duplicatedOne = PersistedProperty(wrappedValue: 5, codingKeyName: TestCodingKey.one)
        let differentKeyProperty = PersistedProperty(wrappedValue: 5, codingKeyName: TestCodingKey.two)
        let differentValueProperty = PersistedProperty(wrappedValue: 7, codingKeyName: TestCodingKey.one)

        XCTAssertNotEqual(propertyOne, propertyTwo)
        XCTAssertNotEqual(propertyOne, differentKeyProperty)
        XCTAssertNotEqual(propertyOne, differentValueProperty)
        XCTAssertEqual(propertyOne, duplicatedOne)
    }

    func testDecode() {
        enum TestCodingKey: String, CodingKey {
            case test
        }

        let mockContainer = MockKeyedDecodingContainer()
        mockContainer.decodeIfPresentValue = 20

        let container = KeyedDecodingContainer<PersistenceCodingKey>(mockContainer)
        let persistedProperty = PersistedProperty(wrappedValue: 10, codingKeyName: TestCodingKey.test)
        do {
            try persistedProperty.decode(from: container)
            XCTAssertEqual(
                persistedProperty,
                PersistedProperty(wrappedValue: 20, codingKeyName: TestCodingKey.test)
            )
            XCTAssertEqual(
                mockContainer.decodeIfPresentKey?.stringValue,
                PersistenceCodingKey(stringValue: TestCodingKey.test.stringValue)?.stringValue
            )
            XCTAssertEqual(mockContainer.decodeIfPresentCallCount, 1)
        }
        catch let error {
            XCTFail("Failed to decode subject: \(error)")
        }
    }

    func testEncode() {
        enum TestCodingKey: String, CodingKey {
            case test
        }

        let mockContainer = MockKeyedEncodingContainer()
        var container = KeyedEncodingContainer<PersistenceCodingKey>(mockContainer)
        let persistedProperty = PersistedProperty(wrappedValue: 10, codingKeyName: TestCodingKey.test)
        do {
            try persistedProperty.encode(to: &container)
            XCTAssertEqual(
                mockContainer.encodeIfPresentValue as? Int,
                10
            )
            XCTAssertEqual(
                mockContainer.encodeIfPresentKey?.stringValue,
                PersistenceCodingKey(stringValue: TestCodingKey.test.stringValue)?.stringValue
            )
            XCTAssertEqual(mockContainer.encodeIfPresentCallCount, 1)
        }
        catch let error {
            XCTFail("Failed to decode subject: \(error)")
        }
    }
}
