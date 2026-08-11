@testable import RickAndMortyApp

extension LocationDTO {
    static func fixture(
        name: String = "Citadel of Ricks",
        url: String = "https://rickandmortyapi.com/api/location/3"
    ) -> LocationDTO {
        LocationDTO(
            name: name,
            url: url
        )
    }
}
