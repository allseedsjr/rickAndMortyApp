import Foundation

protocol SearchCharactersUseCasing {
    func execute(
        characters: [Character],
        query: String
    ) -> [Character]
}

struct SearchCharactersUseCase: SearchCharactersUseCasing {
    func execute(
        characters: [Character],
        query: String
    ) -> [Character] {
        let normalizedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !normalizedQuery.isEmpty else {
            return characters
        }

        return characters.filter {
            $0.name.localizedCaseInsensitiveContains(normalizedQuery)
        }
    }
}
