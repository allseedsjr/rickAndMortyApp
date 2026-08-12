@testable import RickAndMortyApp

final class CharacterSearchFilterSpy: CharacterSearchFiltering {
    private(set) var receivedCharacters: [[CharacterCellViewModel]] = []
    private(set) var receivedQueries: [String] = []
    var result: [CharacterCellViewModel]?

    func filter(
        _ characters: [CharacterCellViewModel],
        by query: String
    ) -> [CharacterCellViewModel] {
        receivedCharacters.append(characters)
        receivedQueries.append(query)
        return result ?? characters
    }
}
