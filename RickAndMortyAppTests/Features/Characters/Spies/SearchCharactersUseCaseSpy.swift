@testable import RickAndMortyApp

final class SearchCharactersUseCaseSpy: SearchCharactersUseCasing {
    private(set) var receivedCharacters: [[Character]] = []
    private(set) var receivedQueries: [String] = []
    var result: [Character]?

    func execute(
        characters: [Character],
        query: String
    ) -> [Character] {
        receivedCharacters.append(characters)
        receivedQueries.append(query)
        return result ?? characters
    }
}
