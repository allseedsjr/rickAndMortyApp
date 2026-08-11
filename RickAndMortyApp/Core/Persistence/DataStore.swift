import Foundation

protocol DataStore {
    func read() throws -> Data?
    func write(_ data: Data) throws
}
