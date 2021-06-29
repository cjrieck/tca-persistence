@testable import Persistence

final class MockKeyedEncodingContainer: KeyedEncodingContainerProtocol {
    private(set) var encodeIfPresentValue: Any? = nil
    private(set) var encodeIfPresentKey: PersistenceCodingKey? = nil
    private(set) var encodeIfPresentCallCount = 0

    private(set) var codingPath: [CodingKey] = []

    func encodeNil(forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Bool, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: String, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Double, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Float, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Int, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Int8, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Int16, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Int32, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: Int64, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: UInt, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: UInt8, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: UInt16, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: UInt32, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode(_ value: UInt64, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encode<T>(_ value: T, forKey key: PersistenceCodingKey) throws where T: Encodable { fatalError() }
    func encodeIfPresent(_ value: Bool?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: String?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: Double?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: Float?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: Int?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: Int8?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: Int16?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: Int32?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: Int64?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: UInt?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: UInt8?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: UInt16?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: UInt32?, forKey key: PersistenceCodingKey) throws { fatalError() }
    func encodeIfPresent(_ value: UInt64?, forKey key: PersistenceCodingKey) throws { fatalError() }

    func encodeIfPresent<T>(_ value: T?, forKey key: PersistenceCodingKey) throws where T: Encodable {
        encodeIfPresentValue = value
        encodeIfPresentKey = key
        encodeIfPresentCallCount += 1
    }
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: PersistenceCodingKey) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("nestedContainer(keyedBy:forKey:) has not been implemented")
    }
    func nestedUnkeyedContainer(forKey key: PersistenceCodingKey) -> UnkeyedEncodingContainer {
        fatalError("nestedUnkeyedContainer(forKey:) has not been implemented")
    }
    func superEncoder() -> Encoder {
        fatalError("superEncoder() has not been implemented")
    }
    func superEncoder(forKey key: PersistenceCodingKey) -> Encoder {
        fatalError("superEncoder(forKey:) has not been implemented")
    }
}

final class MockKeyedDecodingContainer: KeyedDecodingContainerProtocol {
    private(set) var decodeIfPresentKey: PersistenceCodingKey? = nil
    var decodeIfPresentValue: Any? = nil
    private(set) var decodeIfPresentCallCount = 0

    private(set) var codingPath: [CodingKey] = []
    private(set) var allKeys: [PersistenceCodingKey] = []

    func contains(_ key: PersistenceCodingKey) -> Bool {
        allKeys.contains { $0.stringValue == key.stringValue }
    }
    func decodeNil(forKey key: PersistenceCodingKey) throws -> Bool { fatalError() }
    func decode(_ type: Bool.Type, forKey key: PersistenceCodingKey) throws -> Bool { fatalError() }
    func decode(_ type: String.Type, forKey key: PersistenceCodingKey) throws -> String { fatalError() }
    func decode(_ type: Double.Type, forKey key: PersistenceCodingKey) throws -> Double { fatalError() }
    func decode(_ type: Float.Type, forKey key: PersistenceCodingKey) throws -> Float { fatalError() }
    func decode(_ type: Int.Type, forKey key: PersistenceCodingKey) throws -> Int { fatalError() }
    func decode(_ type: Int8.Type, forKey key: PersistenceCodingKey) throws -> Int8 { fatalError() }
    func decode(_ type: Int16.Type, forKey key: PersistenceCodingKey) throws -> Int16 { fatalError() }
    func decode(_ type: Int32.Type, forKey key: PersistenceCodingKey) throws -> Int32 { fatalError() }
    func decode(_ type: Int64.Type, forKey key: PersistenceCodingKey) throws -> Int64 { fatalError() }
    func decode(_ type: UInt.Type, forKey key: PersistenceCodingKey) throws -> UInt { fatalError() }
    func decode(_ type: UInt8.Type, forKey key: PersistenceCodingKey) throws -> UInt8 { fatalError() }
    func decode(_ type: UInt16.Type, forKey key: PersistenceCodingKey) throws -> UInt16 { fatalError() }
    func decode(_ type: UInt32.Type, forKey key: PersistenceCodingKey) throws -> UInt32 { fatalError() }
    func decode(_ type: UInt64.Type, forKey key: PersistenceCodingKey) throws -> UInt64 { fatalError() }
    func decode<T>(_ type: T.Type, forKey key: PersistenceCodingKey) throws -> T where T : Decodable { fatalError() }
    func decodeIfPresent(_ type: Bool.Type, forKey key: PersistenceCodingKey) throws -> Bool? { fatalError() }
    func decodeIfPresent(_ type: String.Type, forKey key: PersistenceCodingKey) throws -> String? { fatalError() }
    func decodeIfPresent(_ type: Double.Type, forKey key: PersistenceCodingKey) throws -> Double? { fatalError() }
    func decodeIfPresent(_ type: Float.Type, forKey key: PersistenceCodingKey) throws -> Float? { fatalError() }
    func decodeIfPresent(_ type: Int.Type, forKey key: PersistenceCodingKey) throws -> Int? { fatalError() }
    func decodeIfPresent(_ type: Int8.Type, forKey key: PersistenceCodingKey) throws -> Int8? { fatalError() }
    func decodeIfPresent(_ type: Int16.Type, forKey key: PersistenceCodingKey) throws -> Int16? { fatalError() }
    func decodeIfPresent(_ type: Int32.Type, forKey key: PersistenceCodingKey) throws -> Int32? { fatalError() }
    func decodeIfPresent(_ type: Int64.Type, forKey key: PersistenceCodingKey) throws -> Int64? { fatalError() }
    func decodeIfPresent(_ type: UInt.Type, forKey key: PersistenceCodingKey) throws -> UInt? { fatalError() }
    func decodeIfPresent(_ type: UInt8.Type, forKey key: PersistenceCodingKey) throws -> UInt8? { fatalError() }
    func decodeIfPresent(_ type: UInt16.Type, forKey key: PersistenceCodingKey) throws -> UInt16? { fatalError() }
    func decodeIfPresent(_ type: UInt32.Type, forKey key: PersistenceCodingKey) throws -> UInt32? { fatalError() }
    func decodeIfPresent(_ type: UInt64.Type, forKey key: PersistenceCodingKey) throws -> UInt64? { fatalError() }

    func decodeIfPresent<T>(_ type: T.Type, forKey key: PersistenceCodingKey) throws -> T? where T : Decodable {
        guard let stubValue = decodeIfPresentValue as? T else { fatalError() }
        decodeIfPresentCallCount += 1
        decodeIfPresentKey = key
        return stubValue
    }
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: PersistenceCodingKey) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey { fatalError() }
    func nestedUnkeyedContainer(forKey key: PersistenceCodingKey) throws -> UnkeyedDecodingContainer { fatalError() }
    func superDecoder() throws -> Decoder { fatalError() }
    func superDecoder(forKey key: PersistenceCodingKey) throws -> Decoder { fatalError() }
}
