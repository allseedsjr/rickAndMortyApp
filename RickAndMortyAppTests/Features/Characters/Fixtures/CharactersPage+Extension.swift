@testable import RickAndMortyApp

extension CharactersPage {
    static func fixture(
        characters: [Character] = [],
        hasNextPage: Bool = false
    ) -> CharactersPage {
        CharactersPage(
            characters: characters,
            hasNextPage: hasNextPage
        )
    }
}
