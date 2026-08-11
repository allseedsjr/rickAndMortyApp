import Foundation

extension URLRequest {
    static func fixture(
        url: URL = URL(string: "https://example.com/resource")!,
        method: String = "GET",
        headers: [String: String] = [:],
        body: Data? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = body
        return request
    }
}
