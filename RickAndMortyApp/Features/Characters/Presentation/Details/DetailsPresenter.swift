@MainActor
protocol DetailsPresentationLogic {
    func presentCharacter(_ character: Character)
    func presentFirstSeenInLoading()
    func presentFirstSeenIn(_ firstSeenIn: FirstSeenIn)
    func presentFirstSeenInUnavailable()
    func presentFirstSeenInError(_ error: any Error)
}

@MainActor
final class DetailsPresenter: DetailsPresentationLogic {
    weak var view: (any DetailsDisplayLogic)?

    private let mapper: any DetailsViewModelMapping
    private let errorMapper: any ErrorViewModelMapping

    init(
        mapper: any DetailsViewModelMapping,
        errorMapper: any ErrorViewModelMapping
    ) {
        self.mapper = mapper
        self.errorMapper = errorMapper
    }

    func presentCharacter(_ character: Character) {
        view?.displayCharacter(mapper.map(character))
    }

    func presentFirstSeenInLoading() {
        view?.displayFirstSeenInLoading()
    }

    func presentFirstSeenIn(_ firstSeenIn: FirstSeenIn) {
        view?.displayFirstSeenIn(mapper.map(firstSeenIn))
    }

    func presentFirstSeenInUnavailable() {
        view?.displayFirstSeenInUnavailable()
    }

    func presentFirstSeenInError(_ error: any Error) {
        view?.displayFirstSeenInError(errorMapper.map(error))
    }
}
