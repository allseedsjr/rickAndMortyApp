protocol EpisodeRepositoryProtocol {
    func getEpisode(id: Int) async throws -> Episode
}
