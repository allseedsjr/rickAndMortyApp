import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(page: Int) async throws -> CharactersPage
}
