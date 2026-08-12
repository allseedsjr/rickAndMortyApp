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

private enum Constants {
    static let paginationThreshold = 8
}

private enum Strings {
    static let screenTitle = "List of Characters"
    static let searchPlaceholder = "Search characters"
    static let searchAccessibilityLabel = "Search characters"
    static let retry = "Retry"
    static let cancel = "Cancel"
}

extension HomeViewController: HomeDisplaying {
    func showLoading() {
        isInitialLoading = true
        isPaginationLoading = false
        homeView.setLoading(true)
        homeView.setSearchEmptyState(false)
    }

    func showCharacters(_ characters: [CharacterCellViewModel]) {
        isInitialLoading = false
        isPaginationLoading = false
        self.characters = characters
        homeView.setLoading(false)
        homeView.tableView.reloadData()
    }

    func appendCharacters(_ characters: [CharacterCellViewModel]) {
        isPaginationLoading = false
        homeView.setPaginationLoading(false)

        guard !characters.isEmpty else {
            homeView.tableView.reloadData()
            return
        }

        self.characters.append(contentsOf: characters)
        homeView.tableView.reloadData()
    }

    func showSearchEmptyState(_ isVisible: Bool) {
        homeView.setSearchEmptyState(isVisible)
    }

    func showPaginationLoading(_ isLoading: Bool) {
        guard isLoading != isPaginationLoading else {
            return
        }

        isPaginationLoading = isLoading
        homeView.setPaginationLoading(isLoading)
    }

    func showError(_ error: ErrorViewModel) {
        isInitialLoading = false
        isPaginationLoading = false
        homeView.setLoading(false)
        homeView.setPaginationLoading(false)
        homeView.tableView.reloadData()

        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        if error.allowsRetry {
            alert.addAction(
                UIAlertAction(
                    title: Strings.retry,
                    style: .default
                ) { [weak self] _ in
                    self?.presenter.retryInitialLoading()
                }
            )
        }
        alert.addAction(
            UIAlertAction(
                title: Strings.cancel,
                style: .cancel
            )
        )
        present(alert, animated: true)
    }

    func showPaginationError(_ error: ErrorViewModel) {
        guard presentedViewController == nil else {
            return
        }

        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        if error.allowsRetry {
            alert.addAction(
                UIAlertAction(
                    title: Strings.retry,
                    style: .default
                ) { [weak self] _ in
                    self?.presenter.retryNextPage()
                }
            )
        }
        alert.addAction(
            UIAlertAction(
                title: Strings.cancel,
                style: .cancel
            ) { [weak self] _ in
                self?.presenter.dismissPaginationError()
            }
        )
        present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        characters.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: characters[indexPath.row])
        return cell
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard characters.indices.contains(indexPath.row) else {
            return
        }

        let characterID = characters[indexPath.row].id
        presenter.didSelectCharacter(id: characterID)
    }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
    func tableView(
        _ tableView: UITableView,
        prefetchRowsAt indexPaths: [IndexPath]
    ) {
        guard !isInitialLoading,
              !characters.isEmpty,
              searchController.searchBar.text?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty != false else {
            return
        }

        let triggerIndex = characters.count - Constants.paginationThreshold
        guard indexPaths.contains(where: { $0.row >= triggerIndex }) else {
            return
        }

        presenter.loadNextPage()
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.searchCharacters(
            with: searchController.searchBar.text ?? ""
        )
    }
}

extension HomeViewController {
    func setupContent() {
        title = Strings.screenTitle
        searchController.searchBar.placeholder = Strings.searchPlaceholder
        searchController.searchBar.accessibilityLabel = Strings.searchAccessibilityLabel
    }

    func setupSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
}
