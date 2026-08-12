import UIKit

@MainActor
protocol HomeRouting {
    func showDetails(for character: Character)
}

@MainActor
final class HomeRouter: HomeRouting {
    weak var viewController: UIViewController?

    func showDetails(for character: Character) {
        let detailsViewController = DetailsModuleFactory.make(character: character)
        viewController?.navigationController?.pushViewController(
            detailsViewController,
            animated: true
        )
    }
}
