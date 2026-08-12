import UIKit

@MainActor
protocol HomeDisplaying: AnyObject {
    func showLoading()
    func showCharacters(_ characters: [CharacterCellViewModel])
    func appendCharacters(_ characters: [CharacterCellViewModel])
    func showSearchEmptyState(_ isVisible: Bool)
    func showPaginationLoading(_ isLoading: Bool)
    func showPaginationError(_ error: ErrorViewModel)
    func showError(_ error: ErrorViewModel)
}

final class HomeViewController: UIViewController {
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    let presenter: any HomePresenting
    let homeView: any HomeViewing
    var characters: [CharacterCellViewModel] = []
    var isInitialLoading = false
    var isPaginationLoading = false

    init(
        presenter: any HomePresenting,
        homeView: any HomeViewing
    ) {
        self.presenter = presenter
        self.homeView = homeView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func loadView() {
        view = homeView.rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.prefetchDataSource = self
        searchController.searchResultsUpdater = self
        setupContent()
        setupNavigationBar()
        setupSearchController()
        presenter.viewDidLoad()
    }
}
