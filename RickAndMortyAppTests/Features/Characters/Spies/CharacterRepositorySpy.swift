@testable import RickAndMortyApp

final class CharacterRepositorySpy: CharacterRepositoryProtocol {
    var onRequestCompleted: (() -> Void)?
    private(set) var receivedPages: [Int] = []
    var result: Result<CharactersPage, Error> = .failure(
        CharacterRepositorySpyError.missingStub
    )

    func getCharacters(page: Int) async throws -> CharactersPage {
        receivedPages.append(page)
        defer { onRequestCompleted?() }
        return try result.get()
    }
}

private enum CharacterRepositorySpyError: Error {
    case missingStub
}
