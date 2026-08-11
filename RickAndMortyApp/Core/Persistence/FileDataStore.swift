import Foundation

final class FileDataStore: DataStore {
    private let fileURL: URL
    private let fileManager: FileManager

    init(
        fileURL: URL,
        fileManager: FileManager = .default
    ) {
        self.fileURL = fileURL
        self.fileManager = fileManager
    }

    func read() throws -> Data? {
        do {
            return try Data(contentsOf: fileURL)
        } catch let error as CocoaError
            where error.code == .fileReadNoSuchFile {
            return nil
        } catch {
            throw error
        }
    }

    func write(_ data: Data) throws {
        let directoryURL = fileURL.deletingLastPathComponent()

        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        try data.write(
            to: fileURL,
            options: [.atomic, .completeFileProtection]
        )
    }
}
