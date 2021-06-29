import Foundation
import SwiftUI

@propertyWrapper
public final class PersistedProperty<Value: Codable> {
    public var wrappedValue: Value
    public var codingKeyName: CodingKey

    public init(wrappedValue: Value, codingKeyName: CodingKey) {
        self.wrappedValue = wrappedValue
        self.codingKeyName = codingKeyName
    }
}

extension PersistedProperty: Equatable where Value: Equatable {
    public static func == (lhs: PersistedProperty<Value>, rhs: PersistedProperty<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue &&
        lhs.codingKeyName.stringValue == rhs.codingKeyName.stringValue
    }
}

protocol DecodablePersistenceProperty {
    typealias DecodingContainer = KeyedDecodingContainer<PersistenceCodingKey>
    func decode(from container: DecodingContainer) throws
}

protocol EncodablePersistenceProperty {
    typealias EncodingContainer = KeyedEncodingContainer<PersistenceCodingKey>
    func encode(to encoder: inout EncodingContainer) throws
}

typealias CodablePersistedProperty = DecodablePersistenceProperty & EncodablePersistenceProperty

extension PersistedProperty: CodablePersistedProperty where Value: Codable {
    func decode(from container: DecodingContainer) throws {
        let key = PersistenceCodingKey(stringValue: codingKeyName.stringValue)
        if let key = key, let value = try container.decodeIfPresent(Value.self, forKey: key) {
            wrappedValue = value
        }
    }

    func encode(to encoder: inout EncodingContainer) throws {
        guard let key = PersistenceCodingKey(stringValue: codingKeyName.stringValue) else { return }
        try encoder.encodeIfPresent(wrappedValue, forKey: key)
    }
}
