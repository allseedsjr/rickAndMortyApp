@testable import RickAndMortyApp

extension EpisodeDTO {
    static func fixture(
        id: Int = 1,
        name: String = "Pilot",
        episode: String = "S01E01",
        airDate: String = "December 2, 2013"
    ) -> EpisodeDTO {
        EpisodeDTO(
            id: id,
            name: name,
            episode: episode,
            airDate: airDate
        )
    }
}
