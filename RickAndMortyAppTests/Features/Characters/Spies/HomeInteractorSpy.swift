@testable import RickAndMortyApp

final class HomeInteractorSpy: HomeInteracting {
    var onRequestCompleted: (() -> Void)?
    private(set) var receivedPages: [Int] = []
    var result: Result<CharactersPage, Error> = .success(.fixture())

    func getCharacters(page: Int) async throws -> CharactersPage {
        receivedPages.append(page)
        defer { onRequestCompleted?() }
        return try result.get()
    }
}
