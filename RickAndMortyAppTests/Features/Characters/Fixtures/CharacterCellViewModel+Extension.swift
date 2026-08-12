import UIKit
@testable import RickAndMortyApp

extension CharacterCellViewModel {
    static func fixture(
        name: String = "Rick Sanchez",
        status: String = "Alive",
        species: String = "Human",
        statusColor: UIColor = .systemGreen,
        imageURL: URL? = URL(string: "https://example.com/rick.jpeg")
    ) -> CharacterCellViewModel {
        CharacterCellViewModel(
            name: name,
            status: status,
            species: species,
            statusColor: statusColor,
            imageURL: imageURL
        )
    }
}
