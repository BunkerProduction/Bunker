//
//  AttributeCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 11.08.2022.
//

import UIKit

final class AttributeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AttributeCollectionViewCell"

    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var borderColorNormal: CGColor?

    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                    self.layer.borderWidth = 2
                    self.layer.borderColor = UIColor.Main.Primary.colorFor(UserSettings.shared.appearance)?.cgColor
                }) {_ in self.transform = CGAffineTransform.identity}
            } else {
                self.layer.borderColor = borderColorNormal ?? UIColor.systemGray5.cgColor
                self.layer.borderWidth = 0
            }
        }
    }

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
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        titleLabel.font = .customFont.body
        descriptionLabel.font = .customFont.footnote
        iconLabel.font = .customFont.icon
        self.layer.cornerRadius = 12

        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel])
        stackView.alignment = .top
        stackView.axis = .vertical
        stackView.spacing = 8

        self.addSubview(stackView)

        stackView.pin(to: self, [.left: 16, .right: 16, .bottom: 16, .top: 16])
    }

    // MARK: - Configure
    public func configure(_ attribute: Attribute) {
        iconLabel.setCustomAttributedText(
            string: attribute.icon,
            font: .customFont.icon,
            1
        )
        titleLabel.setCustomAttributedText(
            string: attribute.type.rawValue,
            font: .customFont.body ?? .systemFont(ofSize: 0),
            1
        )
        descriptionLabel.setCustomAttributedText(
            string: attribute.description,
            font: .customFont.footnote ?? .systemFont(ofSize: 0),
            1.25
        )
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        titleLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        descriptionLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
    }
}
