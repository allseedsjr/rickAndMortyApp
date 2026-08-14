@testable import RickAndMortyApp

final class AppErrorMapperSpy: AppErrorMapping {
    private(set) var receivedErrors: [any Error] = []
    var result: any Error = AppError.unknown

    func map(_ error: any Error) -> any Error {
        receivedErrors.append(error)
        return result
    }
}
