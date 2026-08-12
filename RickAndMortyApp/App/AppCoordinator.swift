import UIKit

@MainActor
protocol AppCoordinating: AnyObject {
    func start()
}

@MainActor
final class AppCoordinator: AppCoordinating {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewController = HomeModuleFactory.make(router: self)
        navigationController.setViewControllers(
            [homeViewController],
            animated: false
        )
    }
}
