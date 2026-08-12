struct GetEpisodeRequest: APIRequest {
    typealias Response = EpisodeDTO

    let episodeID: Int

    var path: String {
        "\(APIEndpoint.Path.episode.rawValue)/\(episodeID)"
    }
}
