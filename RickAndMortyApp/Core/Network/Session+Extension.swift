import Alamofire
import Foundation

extension Alamofire.Session: HTTPSession {
    func execute(
        _ request: URLRequest
    ) async throws -> HTTPResponse {
        let response = await self
            .request(request)
            .serializingData()
            .response

        switch response.result {
        case .success(let data):
            guard let httpResponse = response.response else {
                throw NetworkError.transport
            }

            return HTTPResponse(
                data: data,
                statusCode: httpResponse.statusCode
            )

        case .failure(let error):
            throw NetworkErrorMapper.map(
                map(error)
            )
        }
    }
}

private extension Alamofire.Session {
    func map(
        _ error: AFError
    ) -> HTTPSessionFailure {
        if error.isExplicitlyCancelledError {
            return .cancelled
        }

        guard let urlError = error.underlyingError as? URLError else {
            return .unknown
        }

        return .url(urlError.code)
    }
}
