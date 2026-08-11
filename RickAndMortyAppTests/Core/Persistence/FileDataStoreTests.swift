import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("FileDataStore")
struct FileDataStoreTests {
    @Test
    func testRead_WhenFileDoesNotExist_ReturnsNil() throws {
        let (sut, directoryURL) = makeSUT()
        defer { try? FileManager.default.removeItem(at: directoryURL) }

        let data = try sut.read()

        #expect(data == nil)
    }

    @Test
    func testWrite_WhenDirectoryDoesNotExist_CreatesDirectoryAndFile() throws {
        let (sut, directoryURL) = makeSUT()
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        let expectedData = Data("cached-characters".utf8)

        try sut.write(expectedData)

        #expect(FileManager.default.fileExists(atPath: directoryURL.path))
        #expect(try sut.read() == expectedData)
    }

    @Test
    func testWrite_WhenFileExists_ReplacesPreviousData() throws {
        let (sut, directoryURL) = makeSUT()
        defer { try? FileManager.default.removeItem(at: directoryURL) }

        try sut.write(Data("old-cache".utf8))
        try sut.write(Data("new-cache".utf8))

        #expect(try sut.read() == Data("new-cache".utf8))
    }

    private func makeSUT() -> (
        sut: FileDataStore,
        directoryURL: URL
    ) {
        let directoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let fileURL = directoryURL
            .appendingPathComponent("nested")
            .appendingPathComponent("characters-cache.json")

        return (
            FileDataStore(fileURL: fileURL),
            directoryURL
        )
    }
}
