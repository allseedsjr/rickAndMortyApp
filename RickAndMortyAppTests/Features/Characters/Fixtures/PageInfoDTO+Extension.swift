@testable import RickAndMortyApp

extension PageInfoDTO {
    static func fixture(
        count: Int = 826,
        pages: Int = 42,
        next: String? = "https://rickandmortyapi.com/api/character?page=2",
        prev: String? = nil
    ) -> PageInfoDTO {
        PageInfoDTO(
            count: count,
            pages: pages,
            next: next,
            prev: prev
        )
    }
}
