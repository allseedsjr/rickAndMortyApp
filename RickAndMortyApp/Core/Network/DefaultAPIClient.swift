import Foundation

final class DefaultAPIClient: APIClient {
    private let baseURL: String
    private let transport: HTTPTransport
    private let decoder: JSONDecoder

    init(
        baseURL: String,
        transport: HTTPTransport,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.transport = transport
        self.decoder = decoder
    }

    func execute<Request: APIRequest>(
        _ request: Request
    ) async throws -> Request.Response {
        let urlRequest = try makeURLRequest(
            from: request
        )

        let response = try await transport.execute(
            urlRequest
        )

        guard 200..<300 ~= response.statusCode else {
            throw NetworkError.http(
                statusCode: response.statusCode
            )
        }

        do {
            return try decoder.decode(
                Request.Response.self,
                from: response.data
            )
        } catch {
            throw NetworkError.decoding
        }
    }

    private func makeURLRequest<Request: APIRequest>(
        from request: Request
    ) throws -> URLRequest {
        guard var components = URLComponents(
            string: baseURL
        ) else {
            throw NetworkError.invalidURL
        }

        components.path = request.path

        if !request.queryItems.isEmpty {
            components.queryItems = request.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = request.method.rawValue

        request.headers.forEach { key, value in
            urlRequest.setValue(
                value,
                forHTTPHeaderField: key
            )
        }

        return urlRequest
    }
}
