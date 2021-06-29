enum Screen: Equatable, Codable {
    case home
    case account(String)

    private enum CodingKeys: String, CodingKey {
        case home
        case account
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(String.self, forKey: .account) {
            self = .account(value)
        }
        else if let _ = try? container.decode(Bool.self, forKey: .home) {
            self = .home
        }
        else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Data doesn't match!"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .home:
            try container.encode(true, forKey: .home)
        case let .account(state):
            try container.encode(state, forKey: .account)
        }
    }
}
