import UIKit

extension AppCoordinator: HomeRouting {
    func showDetails(for character: Character) {
        let detailsViewController = DetailsModuleFactory.make(
            character: character,
            router: self
        )
        navigationController.pushViewController(
            detailsViewController,
            animated: true
        )
    }
}

extension AppCoordinator: DetailsRouting {
    func showHome() {
        navigationController.popViewController(animated: true)
    }
}
