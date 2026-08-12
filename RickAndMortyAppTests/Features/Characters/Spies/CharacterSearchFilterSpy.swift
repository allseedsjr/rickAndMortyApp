@testable import RickAndMortyApp

final class CharacterSearchFilterSpy: CharacterSearchFiltering {
    private(set) var receivedCharacters: [[Character]] = []
    private(set) var receivedQueries: [String] = []
    var result: [Character]?

    func filter(
        _ characters: [Character],
        by query: String
    ) -> [Character] {
        receivedCharacters.append(characters)
        receivedQueries.append(query)
        return result ?? characters
    }
}
