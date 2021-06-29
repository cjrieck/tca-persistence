import Foundation
import Combine
import XCTest

class MockEncoder<EncodableType>: TopLevelEncoder {
    let encodeReturnValue: Data
    private(set) var encodeCallCount = 0
    private(set) var valueToEncode: EncodableType?
    
    init(encodeReturnValue: Data) {
        self.encodeReturnValue = encodeReturnValue
    }
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        guard let valueToEncode = value as? EncodableType else {
            XCTFail("Return type, \(encodeReturnValue.self) does not match type to decode, \(T.self)")
            throw EncodingError.invalidValue(value, .init(codingPath: [], debugDescription: "Invalid value"))
        }
        self.valueToEncode = valueToEncode
        encodeCallCount += 1
        return encodeReturnValue
    }
}

class MockDecoder<ReturnValue: Decodable>: TopLevelDecoder {
    let decodedReturnValue: ReturnValue
    private(set) var decodeCallCount = 0
    private(set) var valueToDecode: Data?
    
    init(decodedReturnValue: ReturnValue) {
        self.decodedReturnValue = decodedReturnValue
    }
    
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        guard let returnValue = decodedReturnValue as? T else {
            XCTFail("Return type, \(decodedReturnValue.self) does not match type to decode, \(type)")
            throw DecodingError.typeMismatch(type, .init(codingPath: [], debugDescription: "Type mismatch"))
        }
        valueToDecode = from
        decodeCallCount += 1
        return returnValue
    }
}
