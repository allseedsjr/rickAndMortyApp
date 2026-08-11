import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("NetworkErrorMapper")
struct NetworkErrorMapperTests {
    @Test
    func testMap_WhenFailureIsExplicitCancellation_ReturnsCancelled() {
        let error = NetworkErrorMapper.map(.cancelled)

        #expect(error == .cancelled)
    }

    @Test
    func testMap_WhenURLErrorIsCancellation_ReturnsCancelled() {
        let error = NetworkErrorMapper.map(.url(.cancelled))

        #expect(error == .cancelled)
    }

    @Test
    func testMap_WhenURLErrorIsTimeout_ReturnsTimeout() {
        let error = NetworkErrorMapper.map(.url(.timedOut))

        #expect(error == .timeout)
    }

    @Test(
        "testMap_WhenURLErrorIsConnectivityFailure_ReturnsNoConnection",
        arguments: [
            URLError.Code.notConnectedToInternet,
            .networkConnectionLost,
            .cannotFindHost,
            .cannotConnectToHost
        ]
    )
    func testMap_WhenURLErrorIsConnectivityFailure_ReturnsNoConnection(
        _ code: URLError.Code
    ) {
        let error = NetworkErrorMapper.map(.url(code))

        #expect(error == .noConnection)
    }

    @Test
    func testMap_WhenURLErrorIsNotMapped_ReturnsTransport() {
        let error = NetworkErrorMapper.map(.url(.badServerResponse))

        #expect(error == .transport)
    }

    @Test
    func testMap_WhenFailureIsUnknown_ReturnsTransport() {
        let error = NetworkErrorMapper.map(.unknown)

        #expect(error == .transport)
    }
}
