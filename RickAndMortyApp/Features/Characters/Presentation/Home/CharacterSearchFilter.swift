import Foundation

protocol CharacterSearchFiltering {
    func filter(
        _ characters: [CharacterCellViewModel],
        by query: String
    ) -> [CharacterCellViewModel]
}

struct CharacterSearchFilter: CharacterSearchFiltering {
    func filter(
        _ characters: [CharacterCellViewModel],
        by query: String
    ) -> [CharacterCellViewModel] {
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
