protocol APIClient {
    func execute<Request: APIRequest>(
        _ request: Request
    ) async throws -> Request.Response
}
