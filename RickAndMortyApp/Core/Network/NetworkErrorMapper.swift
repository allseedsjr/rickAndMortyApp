import Foundation

enum NetworkErrorMapper {
    static func map(
        _ failure: HTTPSessionFailure
    ) -> NetworkError {
        switch failure {
        case .cancelled,
             .url(.cancelled):
            return .cancelled

        case .url(.timedOut):
            return .timeout

        case .url(.notConnectedToInternet),
             .url(.networkConnectionLost),
             .url(.cannotFindHost),
             .url(.cannotConnectToHost):
            return .noConnection

        case .url,
             .unknown:
            return .transport
        }
    }
}
