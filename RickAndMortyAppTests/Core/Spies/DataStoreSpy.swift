import Foundation
@testable import RickAndMortyApp

final class DataStoreSpy: DataStore {
    var readResult: Result<Data?, Error> = .success(nil)
    var writeError: Error?
    private(set) var receivedData: Data?

    func read() throws -> Data? {
        try readResult.get()
    }

    func write(_ data: Data) throws {
        receivedData = data

        if let writeError {
            throw writeError
        }
    }
}
