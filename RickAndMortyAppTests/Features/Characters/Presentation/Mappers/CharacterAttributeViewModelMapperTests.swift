import Testing
import UIKit
@testable import RickAndMortyApp

@Suite("Character Attribute View Model Mapper")
struct CharacterAttributeViewModelMapperTests {
    private let sut = CharacterAttributeViewModelMapper()

    @Test(arguments: [
        (CharacterStatus.alive, "Alive", UIColor.systemGreen),
        (CharacterStatus.dead, "Dead", UIColor.systemRed),
        (CharacterStatus.unknown, "Unknown", UIColor.systemGray)
    ])
    func testStatusMapping_MapsTextAndColor(
        status: CharacterStatus,
        expectedText: String,
        expectedColor: UIColor
    ) {
        #expect(sut.statusText(for: status) == expectedText)
        #expect(sut.statusColor(for: status) == expectedColor)
    }

    @Test(arguments: [
        (CharacterGender.female, "Female"),
        (CharacterGender.male, "Male"),
        (CharacterGender.genderless, "Genderless"),
        (CharacterGender.unknown, "Unknown")
    ])
    func testGenderMapping_MapsPresentationText(
        gender: CharacterGender,
        expectedText: String
    ) {
        #expect(sut.genderText(for: gender) == expectedText)
    }

    @Test(arguments: [
        (CharacterSpecies.human, "Human"),
        (CharacterSpecies.alien, "Alien"),
        (CharacterSpecies.humanoid, "Humanoid"),
        (CharacterSpecies.animal, "Animal"),
        (CharacterSpecies.robot, "Robot"),
        (CharacterSpecies.mythologicalCreature, "Mythological Creature"),
        (CharacterSpecies.poopybutthole, "Poopybutthole"),
        (CharacterSpecies.cronenberg, "Cronenberg"),
        (CharacterSpecies.disease, "Disease"),
        (CharacterSpecies.planet, "Planet"),
        (CharacterSpecies.unknown, "Unknown"),
        (CharacterSpecies.other("Vampire"), "Vampire")
    ])
    func testSpeciesMapping_MapsPresentationText(
        species: CharacterSpecies,
        expectedText: String
    ) {
        #expect(sut.speciesText(for: species) == expectedText)
    }
}
