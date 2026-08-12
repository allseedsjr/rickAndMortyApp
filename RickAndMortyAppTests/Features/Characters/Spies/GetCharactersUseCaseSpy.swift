@testable import RickAndMortyApp

final class GetCharactersUseCaseSpy: GetCharactersUseCasing {
    var onExecuteCompleted: (() -> Void)?
    private(set) var receivedPages: [Int] = []
    var result: Result<CharactersPage, Error> = .failure(
        GetCharactersUseCaseSpyError.missingStub
    )

    func execute(page: Int) async throws -> CharactersPage {
        receivedPages.append(page)
        defer { onExecuteCompleted?() }
        return try result.get()
    }
}

private enum GetCharactersUseCaseSpyError: Error {
    case missingStub
}
