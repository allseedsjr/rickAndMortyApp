import UIKit
@testable import RickAndMortyApp

extension DetailsViewModel {
    static func fixture(name: String = "Rick Sanchez") -> DetailsViewModel {
        DetailsViewModel(
            name: name,
            status: "Alive",
            statusColor: .systemGreen,
            species: "Human",
            gender: "Male",
            origin: "Earth (C-137)",
            location: "Citadel of Ricks",
            episodeCount: "51",
            imageURL: URL(string: "https://example.com/rick.jpeg")
        )
    }
}
