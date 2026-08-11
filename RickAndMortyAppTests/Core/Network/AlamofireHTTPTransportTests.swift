import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("AlamofireHTTPTransport")
final class AlamofireHTTPTransportTests {
    private let sessionSpy = HTTPSessionSpy()
    private lazy var sut = AlamofireHTTPTransport(session: sessionSpy)

    @Test
    func testExecute_ForwardsRequestToSession() async throws {
        let expectedRequest = URLRequest.fixture()
        sessionSpy.result = .success(HTTPResponse.fixture())

        _ = try await sut.execute(expectedRequest)

        #expect(sessionSpy.receivedRequest == expectedRequest)
    }

    @Test
    func testExecute_WhenSessionSucceeds_ReturnsSessionResponse() async throws {
        let expectedData = Data("response body".utf8)
        sessionSpy.result = .success(
            HTTPResponse.fixture(
                data: expectedData,
                statusCode: 201
            )
        )

        let response = try await sut.execute(URLRequest.fixture())

        #expect(response.data == expectedData)
        #expect(response.statusCode == 201)
    }

    @Test(
        "testExecute_WhenSessionFails_PropagatesError",
        arguments: [
            NetworkError.timeout,
            .noConnection,
            .cancelled,
            .transport
        ]
    )
    func testExecute_WhenSessionFails_PropagatesError(
        _ expectedError: NetworkError
    ) async {
        sessionSpy.result = .failure(expectedError)

        await #expect(throws: expectedError) {
            try await sut.execute(URLRequest.fixture())
        }
    }
}
