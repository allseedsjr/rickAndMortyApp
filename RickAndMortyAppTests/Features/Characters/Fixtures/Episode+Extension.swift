@testable import RickAndMortyApp

extension Episode {
    static func fixture(
        id: Int = 1,
        name: String = "Pilot",
        code: String = "S01E01",
        airDate: String = "December 2, 2013"
    ) -> Episode {
        Episode(id: id, name: name, code: code, airDate: airDate)
    }
}
