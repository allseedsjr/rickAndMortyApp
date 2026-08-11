import Foundation
@testable import RickAndMortyApp

extension HTTPResponse {
    static func fixture(
        data: Data = Data(#"{"id":1,"name":"Rick"}"#.utf8),
        statusCode: Int = 200
    ) -> HTTPResponse {
        HTTPResponse(
            data: data,
            statusCode: statusCode
        )
    }
}
