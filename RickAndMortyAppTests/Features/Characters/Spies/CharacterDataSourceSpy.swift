@testable import RickAndMortyApp

final class CharacterDataSourceSpy: CharacterDataSourceProtocol {
    private(set) var receivedPages: [Int] = []
    var result: Result<CharacterResponseDTO, Error> = .failure(
        CharacterDataSourceSpyError.missingStub
    )

    func getCharacters(
        page: Int
    ) async throws -> CharacterResponseDTO {
        receivedPages.append(page)
        return try result.get()
    }
}

private enum CharacterDataSourceSpyError: Error {
    case missingStub
}
