public protocol PersistedObject: Codable {
    init()
}

extension PersistedObject {
    public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: PersistenceCodingKey.self)
        for child in Mirror(reflecting: self).children {
            if let property = child.value as? DecodablePersistenceProperty {
                try property.decode(from: container)
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PersistenceCodingKey.self)
        for child in Mirror(reflecting: self).children {
            if let property = child.value as? EncodablePersistenceProperty {
                try property.encode(to: &container)
            }
        }
    }
}
