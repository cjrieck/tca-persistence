import Foundation

public struct PersistenceStorage {
    public var save: (Data, String) -> Void
    public var load: (String) -> Data?

    public init(
        save: @escaping (Data, String) -> Void,
        load: @escaping (String) -> Data?
    ) {
        self.save = save
        self.load = load
    }
}
