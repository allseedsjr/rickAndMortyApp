import Testing
@testable import RickAndMortyApp

@Suite("ErrorViewModelMapper")
struct ErrorViewModelMapperTests {
    private let sut = ErrorViewModelMapper()

    @Test(arguments: [
        AppError.noConnection,
        .timeout,
        .rateLimited,
        .serviceUnavailable,
        .unknown
    ])
    func testMap_WhenErrorIsRecoverable_AllowsRetry(_ error: AppError) {
        #expect(sut.map(error).allowsRetry)
    }

    @Test(arguments: [
        AppError.invalidData,
        .accessDenied,
        .notFound
    ])
    func testMap_WhenErrorIsNotRecoverable_DoesNotAllowRetry(_ error: AppError) {
        #expect(!sut.map(error).allowsRetry)
    }

    @Test
    func testMap_WhenThereIsNoConnection_ReturnsConnectivityContent() {
        let result = sut.map(AppError.noConnection)

        #expect(result.title == "No internet connection")
        #expect(result.message == "Check your connection and try again.")
    }

    @Test
    func testMap_WhenRequestTimesOut_ReturnsTimeoutContent() {
        #expect(sut.map(AppError.timeout).title == "Request timed out")
    }

    @Test
    func testMap_WhenRequestsAreRateLimited_ReturnsRateLimitContent() {
        #expect(sut.map(AppError.rateLimited).title == "Too many requests")
    }

    @Test
    func testMap_WhenServiceIsUnavailable_ReturnsUnavailableContent() {
        #expect(sut.map(AppError.serviceUnavailable).title == "Service unavailable")
    }

    @Test
    func testMap_WhenErrorIsUnexpected_ReturnsGenericContent() {
        let result = sut.map(ErrorViewModelMapperTestError.expected)

        #expect(result.title == "Something went wrong")
        #expect(result.allowsRetry)
    }
}

private enum ErrorViewModelMapperTestError: Error {
    case expected
}
