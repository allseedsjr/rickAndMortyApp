import Testing
@testable import RickAndMortyApp

@Suite("CharacterDataSource")
final class CharacterDataSourceTests {
    private let apiClientSpy = APIClientSpy()
    private lazy var sut = CharacterDataSource(
        apiClient: apiClientSpy
    )

    @Test
    func testGetCharacters_ExecutesRequestWithProvidedPage() async throws {
        apiClientSpy.result = .success(CharacterResponseDTO.fixture())

        _ = try await sut.getCharacters(page: 3)

        let request = try #require(
            apiClientSpy.receivedRequest as? GetCharactersRequest
        )
        #expect(request.page == 3)
    }

    @Test
    func testGetCharacters_WhenClientSucceeds_ReturnsResponse() async throws {
        let expectedResponse = CharacterResponseDTO.fixture()
        apiClientSpy.result = .success(expectedResponse)

        let response = try await sut.getCharacters(page: 1)

        #expect(response.info.count == expectedResponse.info.count)
        #expect(response.results.first?.id == expectedResponse.results.first?.id)
        #expect(response.results.first?.name == expectedResponse.results.first?.name)
        #expect(response.results.first?.origin.name == expectedResponse.results.first?.origin.name)
        #expect(response.results.first?.location.name == expectedResponse.results.first?.location.name)
    }

    @Test
    func testGetCharacters_WhenClientFails_PropagatesError() async {
        apiClientSpy.result = .failure(NetworkError.timeout)

        await #expect(throws: NetworkError.timeout) {
            try await sut.getCharacters(page: 1)
        }
    }
}
