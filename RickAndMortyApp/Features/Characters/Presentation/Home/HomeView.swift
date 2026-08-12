import UIKit

final class HomeView: UIView, ViewCode {
    private enum Constants {
        static let rowHeight: CGFloat = 132
        static let verticalContentInset: CGFloat = 8
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    func setupComponent() {
        addSubview(tableView)
    }

    func setupConstrain() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupExtraConfiguration() {
        backgroundColor = .black
        accessibilityIdentifier = "homeView"
    }
}
