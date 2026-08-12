extension FirstSeenIn {
    init(episode: Episode) {
        self.init(
            episodeName: episode.name,
            episodeCode: episode.code,
            airDate: episode.airDate
        )
    }
}
