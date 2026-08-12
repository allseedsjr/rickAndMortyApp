@testable import RickAndMortyApp

extension FirstSeenIn {
    static func fixture(
        episodeName: String = "Pilot",
        episodeCode: String = "S01E01",
        airDate: String = "December 2, 2013"
    ) -> FirstSeenIn {
        FirstSeenIn(
            episodeName: episodeName,
            episodeCode: episodeCode,
            airDate: airDate
        )
    }
}
