@testable import RickAndMortyApp

extension FirstSeenInViewModel {
    static func fixture(episode: String = "Pilot (S01E01)") -> FirstSeenInViewModel {
        FirstSeenInViewModel(episode: episode, airDate: "December 2, 2013")
    }
}
