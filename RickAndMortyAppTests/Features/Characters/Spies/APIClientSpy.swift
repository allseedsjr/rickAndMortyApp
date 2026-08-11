@testable import RickAndMortyApp

final class APIClientSpy: APIClient {
    private(set) var receivedRequest: Any?
    var result: Result<Any, Error> = .failure(APIClientSpyError.missingStub)

    func execute<Request: APIRequest>(
        _ request: Request
    ) async throws -> Request.Response {
        receivedRequest = request

        switch result {
        case .success(let response):
            guard let response = response as? Request.Response else {
                throw APIClientSpyError.invalidResponseType
            }

            return response

        case .failure(let error):
            throw error
        }
    }
}

private enum APIClientSpyError: Error {
    case missingStub
    case invalidResponseType
}
