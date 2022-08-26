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
    private var isBlured: Bool = false
    private var isBlurable: Bool = true
    private var borderColorNormal: CGColor?
    private var dimmingMask: CAShapeLayer?

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

    override func layoutSubviews() {
        super.layoutSubviews()

        if(isBlured && isBlurable) {
            let mutablePath = CGMutablePath()
            mutablePath.addRect(self.bounds)
            dimmingMask = CAShapeLayer()

            guard let dimmingMask = dimmingMask else {
                return
            }
            dimmingMask.path = mutablePath
            dimmingMask.fillRule = .evenOdd
            self.layer.mask = dimmingMask
            dimmingMask.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
//            let animation = CABasicAnimation(keyPath: "fillColor")
//            animation.fromValue = dimmingMask.fillColor
//            animation.toValue = UIColor.white.withAlphaComponent(0.5).cgColor
//            animation.duration = 1.0
//            dimmingMask.add(animation, forKey: nil)
//
//            CATransaction.begin()
//            CATransaction.setDisableActions(true)
//            dimmingMask.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
//            CATransaction.commit()
        } else {
            self.layer.mask = nil
        }
    }

    // MARK: - SetupUI
    private func setupView() {
        iconLabel.font = .customFont.icon
        iconLabel.setHeight(to: 24)

        titleLabel.numberOfLines = 0
        titleLabel.font = .customFont.body
        titleLabel.setHeight(to: "string".size(withAttributes: [.font: UIFont.customFont.body as Any]).height)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .customFont.footnote

        self.layer.cornerRadius = 12

        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel])
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.axis = .vertical
        stackView.spacing = 20

        self.contentView.addSubview(stackView)

        stackView.pin(to: contentView, [.left: 16, .right: 16, .bottom: 16, .top: 16])
    }

    // MARK: - Configure
    public func configure(_ attribute: Attribute, isBlurable: Bool = true) {
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
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setCustomAttributedText(
            string: attribute.description,
            font: .customFont.footnote ?? .systemFont(ofSize: 0),
            1.25
        )
        descriptionLabel.sizeToFit()

        self.isUserInteractionEnabled = !attribute.isExposed
        self.isBlured = attribute.isExposed
        self.isBlurable = isBlurable
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        titleLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        descriptionLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
    }
}
