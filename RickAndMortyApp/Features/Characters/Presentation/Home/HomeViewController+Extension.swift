import UIKit

private enum Strings {
    static let screenTitle = "List of Characters"
    static let searchPlaceholder = "Search characters"
    static let searchAccessibilityLabel = "Search characters"
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

extension HomeViewController: UITableViewDelegate {}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
