struct EpisodeDTO: Codable {
    let id: Int
    let name: String
    let episode: String
    let airDate: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case episode
        case airDate = "air_date"
    }

    init(
        id: Int,
        name: String,
        episode: String,
        airDate: String
    ) {
        self.id = id
        self.name = name
        self.episode = episode
        self.airDate = airDate
    }
}
