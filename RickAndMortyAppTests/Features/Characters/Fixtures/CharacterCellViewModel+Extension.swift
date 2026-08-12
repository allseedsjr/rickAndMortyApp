import UIKit
@testable import RickAndMortyApp

extension CharacterCellViewModel {
    static func fixture(
        id: Int = 1,
        name: String = "Rick Sanchez",
        status: String = "Alive",
        species: String = "Human",
        statusColor: UIColor = .systemGreen,
        imageURL: URL? = URL(string: "https://example.com/rick.jpeg")
    ) -> CharacterCellViewModel {
        CharacterCellViewModel(
            id: id,
            name: name,
            status: status,
            species: species,
            statusColor: statusColor,
            imageURL: imageURL
        )
    }
}
