@testable import RickAndMortyApp

extension OriginDTO {
    static func fixture(
        name: String = "Earth (C-137)",
        url: String = "https://rickandmortyapi.com/api/location/1"
    ) -> OriginDTO {
        OriginDTO(
            name: name,
            url: url
        )
    }
}
