import Testing
@testable import RickAndMortyApp

@Suite("CharactersRepositoryImpl")
final class CharactersRepositoryImplTests {
    private let dataSourceSpy = CharacterDataSourceSpy()
    private lazy var sut = CharactersRepositoryImpl(
        dataSource: dataSourceSpy
    )

    @Test
    func testGetCharacters_ForwardsPageToDataSource() async throws {
        dataSourceSpy.result = .success(.fixture())

        _ = try await sut.getCharacters(page: 3)

        #expect(dataSourceSpy.receivedPages == [3])
    }

    @Test
    func testGetCharacters_WhenDataSourceSucceeds_ReturnsMappedPage() async throws {
        let characterDTO = CharacterDTO.fixture(
            id: 7,
            name: "Squanchy",
            episode: ["episode-1", "episode-2"]
        )
        dataSourceSpy.result = .success(
            .fixture(
                info: .fixture(next: "next-page"),
                results: [characterDTO]
            )
        )

        let page = try await sut.getCharacters(page: 1)

        let character = try #require(page.characters.first)
        #expect(page.characters.count == 1)
        #expect(page.hasNextPage)
        #expect(character.id == 7)
        #expect(character.name == "Squanchy")
        #expect(character.episodeCount == 2)
        #expect(character.firstEpisodeURL == "episode-1")
    }

    @Test
    func testGetCharacters_WhenNextPageDoesNotExist_ReturnsPageWithoutNextPage() async throws {
        dataSourceSpy.result = .success(
            .fixture(
                info: .fixture(next: nil)
            )
        )

        let page = try await sut.getCharacters(page: 1)

        #expect(page.hasNextPage == false)
    }

    @Test
    func testGetCharacters_WhenDataSourceFails_PropagatesError() async {
        dataSourceSpy.result = .failure(NetworkError.timeout)

        await #expect(throws: NetworkError.timeout) {
            try await sut.getCharacters(page: 1)
        }
    }
}
