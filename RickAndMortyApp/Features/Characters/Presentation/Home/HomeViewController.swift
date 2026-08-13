import UIKit

@MainActor
protocol HomeDisplayLogic: AnyObject {
    func displayLoading()
    func displayCharacters(_ characters: [CharacterCellViewModel])
    func displayAdditionalCharacters(_ characters: [CharacterCellViewModel])
    func displaySearchEmptyState(_ isVisible: Bool)
    func displayPaginationLoading(_ isLoading: Bool)
    func displayPaginationError(_ error: ErrorViewModel)
    func displayError(_ error: ErrorViewModel)
    func displaySelectedCharacter(_ character: Character)
}

final class HomeViewController: UIViewController {
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    let interactor: any HomeBusinessLogic
    weak var router: (any HomeRouting)?
    let homeView: any HomeViewing
    var characters: [CharacterCellViewModel] = []
    var isInitialLoading = false
    var isPaginationLoading = false

    init(
        interactor: any HomeBusinessLogic,
        router: any HomeRouting,
        homeView: any HomeViewing
    ) {
        self.interactor = interactor
        self.router = router
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
        interactor.loadInitialCharacters()
    }
}

private enum Constants {
    static let paginationThreshold = 8
}

extension HomeViewController: HomeDisplayLogic {
    func displayLoading() {
        isInitialLoading = true
        isPaginationLoading = false
        homeView.setLoading(true)
        homeView.setSearchEmptyState(false)
    }

    func displayCharacters(_ characters: [CharacterCellViewModel]) {
        isInitialLoading = false
        isPaginationLoading = false
        self.characters = characters
        homeView.setLoading(false)
        homeView.tableView.reloadData()
    }

    func displayAdditionalCharacters(_ characters: [CharacterCellViewModel]) {
        isPaginationLoading = false
        homeView.setPaginationLoading(false)

        guard !characters.isEmpty else {
            homeView.tableView.reloadData()
            return
        }

        self.characters.append(contentsOf: characters)
        homeView.tableView.reloadData()
    }

    func displaySearchEmptyState(_ isVisible: Bool) {
        homeView.setSearchEmptyState(isVisible)
    }

    func displayPaginationLoading(_ isLoading: Bool) {
        guard isLoading != isPaginationLoading else {
            return
        }

        isPaginationLoading = isLoading
        homeView.setPaginationLoading(isLoading)
    }

    func displayError(_ error: ErrorViewModel) {
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
                    title: Strings.Common.retry,
                    style: .default
                ) { [weak self] _ in
                    self?.interactor.retryInitialLoading()
                }
            )
        }
        alert.addAction(
            UIAlertAction(
                title: Strings.Common.cancel,
                style: .cancel
            )
        )
        present(alert, animated: true)
    }

    func displayPaginationError(_ error: ErrorViewModel) {
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
                    title: Strings.Common.retry,
                    style: .default
                ) { [weak self] _ in
                    self?.interactor.retryNextPage()
                }
            )
        }
        alert.addAction(
            UIAlertAction(
                title: Strings.Common.cancel,
                style: .cancel
            ) { [weak self] _ in
                self?.interactor.dismissPaginationError()
            }
        )
        present(alert, animated: true)
    }

    func displaySelectedCharacter(_ character: Character) {
        router?.showDetails(for: character)
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
        interactor.selectCharacter(id: characterID)
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

        interactor.loadNextPage()
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
        interactor.searchCharacters(
            with: searchController.searchBar.text ?? ""
        )
    }
}

extension HomeViewController {
    func setupContent() {
        title = Strings.Home.title
        searchController.searchBar.placeholder = Strings.Home.searchPlaceholder
        searchController.searchBar.accessibilityLabel = Strings.Home.searchAccessibilityLabel
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
