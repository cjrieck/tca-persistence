import Foundation
import Combine

public struct Persistence<Object: PersistedObject> {
    public var save: (Object) throws -> Void
    public var load: () throws -> Object
}

extension Persistence {
    public static func json(
        storage: PersistenceStorage,
        identifier: String
    ) -> Self {
        .live(
            storage: storage,
            identifier: identifier,
            encoder: JSONEncoder(),
            decoder: JSONDecoder()
        )
    }
    
    public static func live<Encoder: TopLevelEncoder, Decoder: TopLevelDecoder>(
        storage: PersistenceStorage,
        identifier: String,
        encoder: Encoder,
        decoder: Decoder
    ) -> Self where Encoder.Output == Data, Decoder.Input == Data {
        .init(
            save: { object in
                let data = try encoder.encode(object)
                storage.save(data, identifier)
            },
            load: {
                guard let data = storage.load(identifier) else {
                    throw NSError(domain: "Decoding Error", code: 1, userInfo: nil)
                }
                return try decoder.decode(Object.self, from: data)
            }
        )
    }
}
