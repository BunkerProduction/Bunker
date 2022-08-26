//
//  CatastrpoheCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.07.2022.
//

import UIKit

final class GameInfoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CatastrpoheCollectionViewCell"

    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let typeLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetupUI
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 48).isActive = true

        self.layer.cornerRadius = 12

        typeLabel.font = .customFont.caption

        let stackView = UIStackView(arrangedSubviews: [iconLabel, typeLabel])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal

        let mainSV = UIStackView(arrangedSubviews: [stackView, titleLabel, descriptionLabel])
        mainSV.distribution = .fill
        mainSV.alignment = .fill
        mainSV.axis = .vertical
        mainSV.spacing = 12

        self.addSubview(mainSV)
        mainSV.pin(to: self, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }

    public func configure(icon: String, title: String, type: String, description: String) {
        self.iconLabel.text = icon
//        iconLabel.backgroundColor = .red
        self.titleLabel.text = title
//        titleLabel.backgroundColor = .blue
        self.typeLabel.text = type
        self.descriptionLabel.setCustomAttributedText(
            string: description,
            font: .customFont.footnote ?? .systemFont(ofSize: 14, weight: .regular),
            1.5
        )
//        descriptionLabel.backgroundColor = .green
//        self.descriptionLabel.numberOfLines = 0
//        self.descriptionLabel.sizeToFit()
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        typeLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
        descriptionLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
    }
}
