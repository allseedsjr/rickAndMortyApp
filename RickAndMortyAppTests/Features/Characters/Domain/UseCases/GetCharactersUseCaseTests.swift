import Testing
@testable import RickAndMortyApp

@Suite("GetCharactersUseCase", .serialized)
final class GetCharactersUseCaseTests {
    private let repositorySpy = CharacterRepositorySpy()
    private lazy var sut = GetCharactersUseCase(repository: repositorySpy)

    @Test
    func testExecute_ForwardsPageToRepository() async throws {
        repositorySpy.result = .success(.fixture())

        _ = try await sut.execute(page: 3)

        #expect(repositorySpy.receivedPages == [3])
    }

    @Test
    func testExecute_WhenRepositorySucceeds_ReturnsCharactersPage() async throws {
        let expectedPage = CharactersPage.fixture(hasNextPage: true)
        repositorySpy.result = .success(expectedPage)

        let page = try await sut.execute(page: 1)

        #expect(page.characters == expectedPage.characters)
        #expect(page.hasNextPage == expectedPage.hasNextPage)
    }

    @Test
    func testExecute_WhenRepositoryFails_PropagatesError() async {
        repositorySpy.result = .failure(GetCharactersUseCaseTestError.expected)

        await #expect(throws: GetCharactersUseCaseTestError.expected) {
            try await sut.execute(page: 1)
        }
    }
}

private enum GetCharactersUseCaseTestError: Error {
    case expected
}
