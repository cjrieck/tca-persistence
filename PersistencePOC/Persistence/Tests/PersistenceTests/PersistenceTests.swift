import XCTest
@testable import Persistence

final class PersistenceTests: XCTestCase {
    struct TestObject: PersistedObject, Equatable {}

    let storageLoadReturnValue = Data()
    let objectIdentifier = "some_identifier"
    fileprivate var storageSaveCalls: [PersistenceStorage.SaveSpy] = []
    fileprivate var storageLoadCalls: [PersistenceStorage.LoadSpy] = []
    var mockStorage: PersistenceStorage!
    var mockEncoder: MockEncoder<TestObject>!
    var mockDecoder: MockDecoder<TestObject>!

    override func setUp() {
        super.setUp()
        storageSaveCalls = []
        storageLoadCalls = []
        mockStorage = .init(
            save: { data, key in
                self.storageSaveCalls.append(PersistenceStorage.SaveSpy(dataToSave: data, saveKey: key))
            },
            load: { key in
                self.storageLoadCalls.append(PersistenceStorage.LoadSpy(loadKey: key, returnValue: self.storageLoadReturnValue))
                return self.storageLoadReturnValue
            }
        )
        mockEncoder = MockEncoder(encodeReturnValue: Data())
        mockDecoder = MockDecoder(decodedReturnValue: TestObject())
    }
    
    func testSave() {
        let persistence = Persistence<TestObject>.live(
            storage: mockStorage,
            identifier: objectIdentifier,
            encoder: mockEncoder,
            decoder: mockDecoder
        )
        
        do {
            let object = TestObject()
            try persistence.save(object)

            XCTAssertEqual(mockEncoder.encodeCallCount, 1)
            XCTAssertEqual(mockEncoder.valueToEncode, object)
            XCTAssertEqual(storageSaveCalls.count, 1)
            XCTAssertEqual(storageSaveCalls.first?.dataToSave, mockEncoder.encodeReturnValue)
            XCTAssertEqual(storageSaveCalls.first?.saveKey, objectIdentifier)
        }
        catch let error {
            XCTFail("Test failed with error: \(error)")
        }
    }

    func testLoad() {
        let persistence = Persistence<TestObject>.live(
            storage: mockStorage,
            identifier: objectIdentifier,
            encoder: mockEncoder,
            decoder: mockDecoder
        )

        do {
            let result = try persistence.load()

            XCTAssertEqual(storageLoadCalls.count, 1)
            XCTAssertEqual(storageLoadCalls.first?.loadKey, objectIdentifier)
            XCTAssertEqual(storageLoadCalls.first?.returnValue, storageLoadReturnValue)

            XCTAssertEqual(mockDecoder.decodeCallCount, 1)
            XCTAssertEqual(mockDecoder.valueToDecode, storageLoadReturnValue)
            XCTAssertEqual(result, mockDecoder.decodedReturnValue)

        }
        catch let error {
            XCTFail("Test failed with error: \(error)")
        }
    }

    func testLoadFailed() {
        let persistence = Persistence<TestObject>.live(
            storage: .init(
                save: { _,_ in fatalError() },
                load: { key in
                    self.storageLoadCalls.append(PersistenceStorage.LoadSpy(loadKey: key, returnValue: nil))
                    return nil
                }
            ),
            identifier: objectIdentifier,
            encoder: mockEncoder,
            decoder: mockDecoder
        )

        XCTAssertThrowsError(try persistence.load()) { error in
            XCTAssertEqual(error as NSError, NSError(domain: "Decoding Error", code: 1, userInfo: nil))
            XCTAssertEqual(storageLoadCalls.count, 1)
            XCTAssertEqual(storageLoadCalls.first?.loadKey, objectIdentifier)
            XCTAssertNil(storageLoadCalls.first?.returnValue)
            XCTAssertEqual(mockDecoder.decodeCallCount, 0)
            XCTAssertNil(mockDecoder.valueToDecode)
        }
    }
}

extension PersistenceStorage {
    fileprivate struct SaveSpy {
        let dataToSave: Data
        let saveKey: String
    }

    fileprivate struct LoadSpy {
        let loadKey: String
        let returnValue: Data?
    }
}
