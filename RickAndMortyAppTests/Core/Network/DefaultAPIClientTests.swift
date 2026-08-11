//
//  DefaultAPIClientTests.swift
//  RickAndMortyApp
//
//  Created by Alcides Junior on 11/08/26.
//

import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("DefaultAPIClient")
@MainActor
final class DefaultAPIClientTests {
    private let baseURL = "https://example.com"
    private let transportSpy = HTTPTransportSpy()
    private lazy var sut = DefaultAPIClient(
        baseURL: baseURL,
        transport: transportSpy
    )

    @Test
    func testExecute_BuildsAndForwardsURLRequestToTransport() async throws {
        let request = APIRequestStub(
            path: "/characters",
            method: .post,
            headers: ["Authorization": "token"],
            queryItems: [
                URLQueryItem(name: "page", value: "2"),
                URLQueryItem(name: "name", value: "Rick Sanchez")
            ]
        )
        transportSpy.result = .success(HTTPResponse.fixture())

        _ = try await sut.execute(request)

        let receivedRequest = try #require(transportSpy.receivedRequest)
        #expect(receivedRequest.url?.scheme == "https")
        #expect(receivedRequest.url?.host == "example.com")
        #expect(receivedRequest.url?.path == "/characters")
        #expect(receivedRequest.url?.query == "page=2&name=Rick%20Sanchez")
        #expect(receivedRequest.httpMethod == "POST")
        #expect(receivedRequest.value(forHTTPHeaderField: "Authorization") == "token")
    }

    @Test(arguments: [200, 299])
    func testExecute_WhenResponseIsSuccessful_DecodesResponse(
        _ statusCode: Int
    ) async throws {
        transportSpy.result = .success(
            HTTPResponse.fixture(
                data: Data(#"{"id":1,"name":"Rick Sanchez"}"#.utf8),
                statusCode: statusCode
            )
        )

        let response = try await sut.execute(APIRequestStub())

        #expect(response == APIResponseStub(id: 1, name: "Rick Sanchez"))
    }

    @Test
    func testExecute_UsesInjectedDecoder() async throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let sut = DefaultAPIClient(
            baseURL: baseURL,
            transport: transportSpy,
            decoder: decoder
        )
        transportSpy.result = .success(
            HTTPResponse.fixture(
                data: Data(#"{"id":1,"full_name":"Morty Smith"}"#.utf8),
                statusCode: 200
            )
        )

        let response = try await sut.execute(CustomDecoderRequestStub())

        #expect(response == CustomDecoderResponseStub(id: 1, fullName: "Morty Smith"))
    }

    @Test(
        "testExecute_WhenStatusCodeIsNotSuccessful_ThrowsHTTPError",
        arguments: [199, 300, 400, 404, 500]
    )
    func testExecute_WhenStatusCodeIsNotSuccessful_ThrowsHTTPError(
        _ statusCode: Int
    ) async {
        transportSpy.result = .success(
            HTTPResponse.fixture(statusCode: statusCode)
        )

        await #expect(throws: NetworkError.http(statusCode: statusCode)) {
            try await sut.execute(APIRequestStub())
        }
    }

    @Test
    func testExecute_WhenResponseCannotBeDecoded_ThrowsDecodingError() async {
        transportSpy.result = .success(
            HTTPResponse.fixture(
                data: Data(#"{"unexpected":true}"#.utf8),
                statusCode: 200
            )
        )

        await #expect(throws: NetworkError.decoding) {
            try await sut.execute(APIRequestStub())
        }
    }

    @Test(
        "testExecute_WhenTransportFails_PropagatesError",
        arguments: [
            NetworkError.timeout,
            .noConnection,
            .cancelled,
            .transport
        ]
    )
    func testExecute_WhenTransportFails_PropagatesError(
        _ expectedError: NetworkError
    ) async {
        transportSpy.result = .failure(expectedError)

        await #expect(throws: expectedError) {
            try await sut.execute(APIRequestStub())
        }
    }

    @Test
    func testExecute_WhenBaseURLIsInvalid_ThrowsInvalidURLError() async {
        let sut = DefaultAPIClient(
            baseURL: "https://[invalid",
            transport: transportSpy
        )

        await #expect(throws: NetworkError.invalidURL) {
            try await sut.execute(APIRequestStub())
        }
        #expect(transportSpy.receivedRequest == nil)
    }
}
