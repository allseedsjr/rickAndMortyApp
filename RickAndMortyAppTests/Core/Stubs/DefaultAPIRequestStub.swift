@testable import RickAndMortyApp

struct DefaultAPIRequestStub: APIRequest {
    typealias Response = APIResponseStub

    let path = "/characters"
}
