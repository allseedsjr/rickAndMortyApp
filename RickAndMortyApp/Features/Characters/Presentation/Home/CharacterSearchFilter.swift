import Foundation

protocol CharacterSearchFiltering {
    func filter(
        _ characters: [Character],
        by query: String
    ) -> [Character]
}

struct CharacterSearchFilter: CharacterSearchFiltering {
    func filter(
        _ characters: [Character],
        by query: String
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
