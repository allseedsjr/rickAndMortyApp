import UIKit

@MainActor
protocol HomeViewing: AnyObject {
    var rootView: UIView { get }
    var tableView: UITableView { get }

    func setLoading(_ isLoading: Bool)
    func setPaginationLoading(_ isLoading: Bool)
}

final class HomeView: UIView, HomeViewing, ViewCode {
    private enum Constants {
        static let rowHeight: CGFloat = 132
        static let verticalContentInset: CGFloat = 8
        static let paginationIndicatorHeight: CGFloat = 44
    }

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = Constants.rowHeight
        tableView.contentInset = UIEdgeInsets(
            top: Constants.verticalContentInset,
            left: 0,
            bottom: Constants.verticalContentInset,
            right: 0
        )
        tableView.register(
            CharacterTableViewCell.self,
            forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier
        )
        return tableView
    }()

    var rootView: UIView {
        self
    }

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let paginationLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    func setLoading(_ isLoading: Bool) {
        tableView.isHidden = isLoading

        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func setPaginationLoading(_ isLoading: Bool) {
        paginationLoadingIndicator.frame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: Constants.paginationIndicatorHeight
        )

        if isLoading {
            tableView.tableFooterView = paginationLoadingIndicator
            paginationLoadingIndicator.startAnimating()
        } else {
            paginationLoadingIndicator.stopAnimating()
            tableView.tableFooterView = nil
        }
    }

    func setupComponent() {
        addSubview(tableView)
        addSubview(loadingIndicator)
    }

    func setupConstrain() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setupExtraConfiguration() {
        backgroundColor = .black
        accessibilityIdentifier = "homeView"
    }
}
