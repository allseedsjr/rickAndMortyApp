import UIKit

final class CharacterTableViewCell: UITableViewCell, ViewCode {
    private enum Constants {
        static let cardBackgroundColor = UIColor(
            red: 12 / 255,
            green: 20 / 255,
            blue: 36 / 255,
            alpha: 1
        )
        static let cardCornerRadius: CGFloat = 14
        static let imageCornerRadius: CGFloat = 10
        static let nameFontSize: CGFloat = 20
        static let nameNumberOfLines = 2
        static let informationFontSize: CGFloat = 17
        static let stackSpacing: CGFloat = 8
        static let cardVerticalInset: CGFloat = 6
        static let cardHorizontalInset: CGFloat = 16
        static let cardContentInset: CGFloat = 14
        static let imageSize: CGFloat = 96
        static let statusIndicatorSize: CGFloat = 10
        static let statusIndicatorCornerRadius = statusIndicatorSize / 2
    }

    static let reuseIdentifier = String(describing: CharacterTableViewCell.self)

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.cardBackgroundColor
        view.layer.cornerRadius = Constants.cardCornerRadius
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.cornerCurve = .continuous
        imageView.backgroundColor = .secondarySystemBackground
        imageView.tintColor = .secondaryLabel
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.nameFontSize, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = Constants.nameNumberOfLines
        return label
    }()

    private let statusIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = Constants.statusIndicatorCornerRadius
        return view
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.informationFontSize, weight: .regular)
        label.textColor = .lightGray
        return label
    }()

    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.informationFontSize, weight: .regular)
        label.textColor = .lightGray
        return label
    }()

    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [statusIndicatorView, statusLabel]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.stackSpacing
        return stackView
    }()

    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [nameLabel, statusStackView, speciesLabel]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.stackSpacing
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        speciesLabel.text = nil
    }

    func configure(with viewModel: CharacterCellViewModel) {
        let placeholder = UIImage(
            systemName: "person.crop.square.fill"
        )
        nameLabel.text = viewModel.name
        statusLabel.text = viewModel.status
        speciesLabel.text = viewModel.species
        statusIndicatorView.backgroundColor = viewModel.statusColor

        characterImageView.image = placeholder
    }

    func setupComponent() {
        contentView.addSubview(cardView)
        cardView.addSubview(characterImageView)
        cardView.addSubview(informationStackView)
    }

    func setupConstrain() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.cardVerticalInset
            ),
            cardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.cardHorizontalInset
            ),
            cardView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.cardHorizontalInset
            ),
            cardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.cardVerticalInset
            ),

            characterImageView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: Constants.cardContentInset
            ),
            characterImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor),

            informationStackView.leadingAnchor.constraint(
                equalTo: characterImageView.trailingAnchor,
                constant: Constants.cardContentInset
            ),
            informationStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: cardView.trailingAnchor,
                constant: -Constants.cardContentInset
            ),
            informationStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            statusIndicatorView.widthAnchor.constraint(
                equalToConstant: Constants.statusIndicatorSize
            ),
            statusIndicatorView.heightAnchor.constraint(equalTo: statusIndicatorView.widthAnchor)
        ])
    }

    func setupExtraConfiguration() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        accessibilityIdentifier = "characterCell"
    }
}
