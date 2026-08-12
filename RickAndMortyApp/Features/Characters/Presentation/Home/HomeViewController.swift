import UIKit

final class HomeViewController: UIViewController {
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    let presenter: any HomePresenting
    let homeView: HomeView
    var characters: [CharacterCellViewModel] = []

    init(presenter: any HomePresenting, homeView: HomeView) {
        self.presenter = presenter
        self.homeView = homeView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

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
        presenter.viewDidLoad()
    }
}
