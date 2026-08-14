import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("AppErrorMapper")
struct AppErrorMapperTests {
    private let sut = AppErrorMapper()

    @Test(arguments: [
        (NetworkError.noConnection, AppError.noConnection),
        (NetworkError.timeout, AppError.timeout),
        (NetworkError.decoding, AppError.invalidData),
        (NetworkError.invalidURL, AppError.invalidData),
        (NetworkError.http(statusCode: 401), AppError.accessDenied),
        (NetworkError.http(statusCode: 403), AppError.accessDenied),
        (NetworkError.http(statusCode: 404), AppError.notFound),
        (NetworkError.http(statusCode: 429), AppError.rateLimited),
        (NetworkError.http(statusCode: 500), AppError.serviceUnavailable),
        (NetworkError.http(statusCode: 503), AppError.serviceUnavailable),
        (NetworkError.http(statusCode: 418), AppError.unknown),
        (NetworkError.transport, AppError.unknown)
    ])
    func testMap_WhenNetworkFails_ReturnsAppError(
        input: NetworkError,
        expected: AppError
    ) {
        let result = sut.map(input) as? AppError

        #expect(result == expected)
    }

    @Test
    func testMap_WhenNetworkRequestIsCancelled_PreservesCancellation() {
        #expect(sut.map(NetworkError.cancelled) is CancellationError)
    }

    @Test
    func testMap_WhenFailureIsCancellation_PreservesCancellation() {
        #expect(sut.map(CancellationError()) is CancellationError)
    }

    @Test
    func testMap_WhenFailureIsAlreadyAnAppError_PreservesError() {
        #expect(sut.map(AppError.timeout) as? AppError == .timeout)
    }

    @Test
    func testMap_WhenFailureIsUnknown_ReturnsUnknownAppError() {
        let result = sut.map(AppErrorMapperTestError.expected)

        #expect(result as? AppError == .unknown)
    }
}

private enum AppErrorMapperTestError: Error {
    case expected
}
