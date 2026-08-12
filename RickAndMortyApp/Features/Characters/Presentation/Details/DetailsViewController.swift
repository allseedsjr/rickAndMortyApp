import UIKit

@MainActor
protocol DetailsDisplaying: AnyObject {
    func showCharacter(_ viewModel: DetailsViewModel)
    func showFirstSeenInLoading()
    func showFirstSeenIn(_ viewModel: FirstSeenInViewModel)
    func showFirstSeenInUnavailable()
    func showFirstSeenInError(_ error: ErrorViewModel)
}

final class DetailsViewController: UIViewController {
    let presenter: any DetailsPresenting
    let detailsView: any DetailsViewing

    init(
        presenter: any DetailsPresenting,
        detailsView: any DetailsViewing
    ) {
        self.presenter = presenter
        self.detailsView = detailsView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func loadView() {
        view = detailsView.rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        detailsView.backButton.addTarget(
            self,
            action: #selector(didTapBack),
            for: .touchUpInside
        )
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

private enum Strings {
    static let retry = "Retry"
    static let cancel = "Cancel"
}

extension DetailsViewController: DetailsDisplaying {
    func showCharacter(_ viewModel: DetailsViewModel) {
        detailsView.configure(with: viewModel)
    }

    func showFirstSeenInLoading() {
        detailsView.setFirstSeenInLoading()
    }

    func showFirstSeenIn(_ viewModel: FirstSeenInViewModel) {
        detailsView.setFirstSeenIn(viewModel)
    }

    func showFirstSeenInUnavailable() {
        detailsView.setFirstSeenInUnavailable()
    }

    func showFirstSeenInError(_ error: ErrorViewModel) {
        detailsView.setFirstSeenInUnavailable()

        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        if error.allowsRetry {
            alert.addAction(
                UIAlertAction(title: Strings.retry, style: .default) { [weak self] _ in
                    self?.presenter.retryFirstSeenIn()
                }
            )
        }
        alert.addAction(
            UIAlertAction(title: Strings.cancel, style: .cancel)
        )
        present(alert, animated: true)
    }
}
