@testable import RickAndMortyApp

struct CustomDecoderRequestStub: APIRequest {
    typealias Response = CustomDecoderResponseStub

    let path = "/characters"
}
