import Kingfisher
import UIKit

@MainActor
protocol DetailsViewing: AnyObject {
    var rootView: UIView { get }
    var backButton: UIButton { get }

    func configure(with viewModel: DetailsViewModel)
    func setFirstSeenInLoading()
    func setFirstSeenIn(_ viewModel: FirstSeenInViewModel)
    func setFirstSeenInUnavailable()
}

final class DetailsView: UIView, DetailsViewing, ViewCode {
    private enum Constants {
        static let backgroundColor = UIColor.black
        static let cardColor = UIColor(red: 12 / 255, green: 20 / 255, blue: 36 / 255, alpha: 1)
        static let horizontalInset: CGFloat = 16
        static let topInset: CGFloat = 16
        static let cardCornerRadius: CGFloat = 14
        static let backButtonSize: CGFloat = 48
        static let imageHeight: CGFloat = 240
        static let imageCornerRadius: CGFloat = 14
        static let cardContentInset: CGFloat = 16
        static let sectionSpacing: CGFloat = 16
        static let contentBottomInset: CGFloat = 32
        static let nameFontSize: CGFloat = 24
        static let bodyFontSize: CGFloat = 17
        static let informationFontSize: CGFloat = 16
        static let statusIndicatorSize: CGFloat = 10
        static let rowSpacing: CGFloat = 12
        static let dividerHeight: CGFloat = 1
    }

    var rootView: UIView { self }

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        button.layer.borderWidth = 1
        button.accessibilityLabel = Strings.Details.backAccessibilityLabel
        return button
    }()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerCard: UIView = DetailsView.makeCard()
    private let informationCard: UIView = DetailsView.makeCard()

    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.imageCornerRadius
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .secondarySystemBackground
        view.tintColor = .secondaryLabel
        view.kf.indicatorType = .activity
        return view
    }()

    private let nameLabel = DetailsView.makeLabel(
        font: .systemFont(ofSize: Constants.nameFontSize, weight: .bold),
        color: .white
    )
    private let statusLabel = DetailsView.makeLabel(
        font: .systemFont(ofSize: Constants.bodyFontSize),
        color: .lightGray
    )
    private let statusIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.statusIndicatorSize / 2
        return view
    }()

    private let speciesValue = DetailsView.makeValueLabel()
    private let genderValue = DetailsView.makeValueLabel()
    private let originValue = DetailsView.makeValueLabel()
    private let locationValue = DetailsView.makeValueLabel()
    private let episodesValue = DetailsView.makeValueLabel()
    private let firstSeenTitle = DetailsView.makeLabel(
        font: .systemFont(ofSize: Constants.bodyFontSize, weight: .semibold),
        color: .white
    )
    private let episodeLabel = DetailsView.makeLabel(
        font: .systemFont(ofSize: Constants.informationFontSize),
        color: .lightGray
    )
    private let airDateLabel = DetailsView.makeLabel(
        font: .systemFont(ofSize: Constants.informationFontSize),
        color: .lightGray
    )
    private let firstSeenLoadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .white
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var statusStack = makeHorizontalStack(
        [statusIndicator, statusLabel],
        spacing: 8
    )
    private lazy var headerInformationStack = makeVerticalStack(
        [nameLabel, statusStack],
        spacing: 8
    )
    private lazy var firstSeenContentStack = makeVerticalStack(
        [episodeLabel, airDateLabel, firstSeenLoadingIndicator],
        spacing: 4
    )
    private lazy var informationStack = makeVerticalStack(
        [
            makeInformationRow(title: Strings.Details.species, value: speciesValue),
            makeInformationRow(title: Strings.Details.gender, value: genderValue),
            makeInformationRow(title: Strings.Details.origin, value: originValue),
            makeInformationRow(title: Strings.Details.location, value: locationValue),
            makeInformationRow(title: Strings.Details.episodes, value: episodesValue),
            makeDivider(),
            firstSeenTitle,
            firstSeenContentStack
        ],
        spacing: Constants.rowSpacing
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = backButton.bounds.height / 2
    }

    func configure(with viewModel: DetailsViewModel) {
        nameLabel.text = viewModel.name
        statusLabel.text = viewModel.status
        statusIndicator.backgroundColor = viewModel.statusColor
        speciesValue.text = viewModel.species
        genderValue.text = viewModel.gender
        originValue.text = viewModel.origin
        locationValue.text = viewModel.location
        episodesValue.text = viewModel.episodeCount

        let placeholder = UIImage(systemName: "person.crop.square.fill")
        guard let imageURL = viewModel.imageURL else {
            characterImageView.image = placeholder
            return
        }
        characterImageView.kf.setImage(with: imageURL, placeholder: placeholder)
    }

    func setFirstSeenInLoading() {
        episodeLabel.text = nil
        airDateLabel.text = nil
        firstSeenLoadingIndicator.startAnimating()
    }

    func setFirstSeenIn(_ viewModel: FirstSeenInViewModel) {
        firstSeenLoadingIndicator.stopAnimating()
        episodeLabel.text = viewModel.episode
        airDateLabel.text = viewModel.airDate
    }

    func setFirstSeenInUnavailable() {
        firstSeenLoadingIndicator.stopAnimating()
        episodeLabel.text = Strings.Common.unavailable
        airDateLabel.text = nil
    }

    func setupComponent() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(headerCard)
        contentView.addSubview(informationCard)
        headerCard.addSubview(characterImageView)
        headerCard.addSubview(headerInformationStack)
        informationCard.addSubview(informationStack)
    }

    func setupConstrain() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topInset),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonSize),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            headerCard.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: Constants.sectionSpacing),
            headerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            headerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),

            characterImageView.topAnchor.constraint(equalTo: headerCard.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),

            headerInformationStack.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: Constants.cardContentInset),
            headerInformationStack.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: Constants.cardContentInset),
            headerInformationStack.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -Constants.cardContentInset),
            headerInformationStack.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -Constants.cardContentInset),

            statusIndicator.widthAnchor.constraint(equalToConstant: Constants.statusIndicatorSize),
            statusIndicator.heightAnchor.constraint(equalTo: statusIndicator.widthAnchor),

            informationCard.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: Constants.sectionSpacing),
            informationCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            informationCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            informationCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentBottomInset),

            informationStack.topAnchor.constraint(equalTo: informationCard.topAnchor, constant: Constants.cardContentInset),
            informationStack.leadingAnchor.constraint(equalTo: informationCard.leadingAnchor, constant: Constants.cardContentInset),
            informationStack.trailingAnchor.constraint(equalTo: informationCard.trailingAnchor, constant: -Constants.cardContentInset),
            informationStack.bottomAnchor.constraint(equalTo: informationCard.bottomAnchor, constant: -Constants.cardContentInset)
        ])
    }

    func setupExtraConfiguration() {
        backgroundColor = Constants.backgroundColor
        firstSeenTitle.text = Strings.Details.firstSeenIn
        accessibilityIdentifier = "detailsView"
    }

    private func makeInformationRow(title: String, value: UILabel) -> UIStackView {
        let titleLabel = Self.makeLabel(
            font: .systemFont(ofSize: Constants.informationFontSize, weight: .semibold),
            color: .lightGray
        )
        titleLabel.text = title
        let stack = makeHorizontalStack([titleLabel, value], spacing: 8)
        stack.distribution = .fill
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        value.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return stack
    }

    private func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        view.heightAnchor.constraint(equalToConstant: Constants.dividerHeight).isActive = true
        return view
    }

    private func makeHorizontalStack(_ views: [UIView], spacing: CGFloat) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = spacing
        return stack
    }

    private func makeVerticalStack(_ views: [UIView], spacing: CGFloat) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = spacing
        return stack
    }

    private static func makeCard() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.cardColor
        view.layer.cornerRadius = Constants.cardCornerRadius
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }

    private static func makeLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        return label
    }

    private static func makeValueLabel() -> UILabel {
        let label = makeLabel(
            font: .systemFont(ofSize: Constants.informationFontSize),
            color: .white
        )
        label.textAlignment = .right
        return label
    }
}
