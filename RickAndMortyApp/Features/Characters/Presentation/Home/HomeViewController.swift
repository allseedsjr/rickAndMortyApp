import UIKit

final class HomeViewController: UIViewController {
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    let homeView = HomeView()
    var characters: [CharacterCellViewModel] = []

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        setupContent()
        setupNavigationBar()
        setupSearchController()
    }
}
