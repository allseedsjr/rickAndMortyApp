import UIKit

@MainActor
protocol DetailsDisplayLogic: AnyObject {
    func displayCharacter(_ viewModel: DetailsViewModel)
    func displayFirstSeenInLoading()
    func displayFirstSeenIn(_ viewModel: FirstSeenInViewModel)
    func displayFirstSeenInUnavailable()
    func displayFirstSeenInError(_ error: ErrorViewModel)
}

final class DetailsViewController: UIViewController {
    let interactor: any DetailsBusinessLogic
    weak var router: (any DetailsRouting)?
    let detailsView: any DetailsViewing

    init(
        interactor: any DetailsBusinessLogic,
        router: any DetailsRouting,
        detailsView: any DetailsViewing
    ) {
        self.interactor = interactor
        self.router = router
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
        interactor.loadDetails()
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
        router?.showHome()
    }
}

extension DetailsViewController: DetailsDisplayLogic {
    func displayCharacter(_ viewModel: DetailsViewModel) {
        detailsView.configure(with: viewModel)
    }

    func displayFirstSeenInLoading() {
        detailsView.setFirstSeenInLoading()
    }

    func displayFirstSeenIn(_ viewModel: FirstSeenInViewModel) {
        detailsView.setFirstSeenIn(viewModel)
    }

    func displayFirstSeenInUnavailable() {
        detailsView.setFirstSeenInUnavailable()
    }

    func displayFirstSeenInError(_ error: ErrorViewModel) {
        detailsView.setFirstSeenInUnavailable()

        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        if error.allowsRetry {
            alert.addAction(
                UIAlertAction(title: Strings.Common.retry, style: .default) { [weak self] _ in
                    self?.interactor.retryFirstSeenIn()
                }
            )
        }
        alert.addAction(
            UIAlertAction(title: Strings.Common.cancel, style: .cancel)
        )
        present(alert, animated: true)
    }
}
