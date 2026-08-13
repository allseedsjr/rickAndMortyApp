import Testing
import UIKit
@testable import RickAndMortyApp

@Suite("CharacterCellViewModelMapper")
struct CharacterCellViewModelMapperTests {
    private let sut = CharacterCellViewModelMapper()

    @Test
    func testMap_WhenCharacterIsProvided_MapsContent() {
        let character = Character.fixture(
            id: 42,
            name: "Morty Smith",
            status: .alive,
            species: .human,
            imageURL: "https://example.com/morty.jpeg"
        )

        let viewModel = sut.map(character)

        #expect(viewModel.id == 42)
        #expect(viewModel.name == "Morty Smith")
        #expect(viewModel.status == "Alive")
        #expect(viewModel.species == "Human")
        #expect(viewModel.imageURL == URL(string: "https://example.com/morty.jpeg"))
    }

    @Test
    func testMap_WhenStatusIsAlive_MapsGreenColor() {
        let character = Character.fixture(status: .alive)

        let viewModel = sut.map(character)

        #expect(viewModel.statusColor == .systemGreen)
    }

    @Test
    func testMap_WhenStatusIsDead_MapsRedColor() {
        let character = Character.fixture(status: .dead)

        let viewModel = sut.map(character)

        #expect(viewModel.statusColor == .systemRed)
    }

    @Test
    func testMap_WhenStatusIsUnknown_MapsGrayColor() {
        let character = Character.fixture(status: .unknown)

        let viewModel = sut.map(character)

        #expect(viewModel.statusColor == .systemGray)
    }

    @Test
    func testMap_WhenImageURLIsInvalid_MapsNilURL() {
        let character = Character.fixture(imageURL: "%")

        let viewModel = sut.map(character)

        #expect(viewModel.imageURL == nil)
    }

    @Test
    func testMap_WhenSpeciesIsOther_PreservesSpeciesText() {
        let character = Character.fixture(species: .other("Vampire"))

        let viewModel = sut.map(character)

        #expect(viewModel.species == "Vampire")
    }
}
