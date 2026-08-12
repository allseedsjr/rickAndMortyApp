import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("EpisodeDTO")
struct EpisodeDTOTests {
    @Test
    func testDecode_WhenPayloadIsValid_MapsAirDate() throws {
        let data = Data(
            #"{"id":1,"name":"Pilot","air_date":"December 2, 2013","episode":"S01E01"}"#.utf8
        )

        let result = try JSONDecoder().decode(EpisodeDTO.self, from: data)

        #expect(result.id == 1)
        #expect(result.name == "Pilot")
        #expect(result.episode == "S01E01")
        #expect(result.airDate == "December 2, 2013")
    }

    @Test
    func testDecode_WhenAirDateIsMissing_ThrowsDecodingError() {
        let data = Data(
            #"{"id":1,"name":"Pilot","episode":"S01E01"}"#.utf8
        )

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(EpisodeDTO.self, from: data)
        }
    }
}
