import Foundation

struct GetCharactersRequest: APIRequest {
    typealias Response = CharacterResponseDTO

    let page: Int

    var path: String {
        APIEndpoint.Path.characters.rawValue
    }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(
                name: "page",
                value: String(page)
            )
        ]
    }
}
