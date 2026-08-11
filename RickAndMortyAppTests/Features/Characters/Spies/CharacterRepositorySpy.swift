@testable import RickAndMortyApp

final class CharacterRepositorySpy: CharacterRepositoryProtocol {
    private(set) var receivedPages: [Int] = []
    var result: Result<CharactersPage, Error> = .failure(
        CharacterRepositorySpyError.missingStub
    )

    func getCharacters(page: Int) async throws -> CharactersPage {
        receivedPages.append(page)
        return try result.get()
    }
}

private enum CharacterRepositorySpyError: Error {
    case missingStub
}
