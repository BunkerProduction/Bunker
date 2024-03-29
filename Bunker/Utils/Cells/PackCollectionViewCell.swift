//
//  PackCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import UIKit

final class PackCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PackCollectionViewCell"
    
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var borderColorNormal: CGColor?
    
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                UIView.animate(
                    withDuration: 0.15,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                        self.layer.borderWidth = 2
                        self.layer.borderColor = UIColor.Main.Primary.colorFor(UserSettings.shared.appearance)?.cgColor
                    },
                    completion: { (_) in
                        self.transform = .identity
                        UIView.animate(
                            withDuration: 0.15,
                            delay: 0,
                            options: .curveEaseOut,
                            animations: {
                                self.transform = .identity
                            },
                            completion: nil
                        )
                    }
                )
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
        self.layer.cornerCurve = .continuous
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 8
        
        self.addSubview(stackView)
        
        stackView.pin(to: self, [.left: 16, .right: 16, .bottom: 16, .top: 16])
    }
    
    // MARK: - Configure
    public func configure(_ pack: Catastrophe) {
        iconLabel.setCustomAttributedText(
            string: pack.icon,
            font: .customFont.icon,
            1
        )
        titleLabel.setCustomAttributedText(
            string: pack.name,
            font: .customFont.body ?? .systemFont(ofSize: 0),
            1
        )
        descriptionLabel.setCustomAttributedText(
            string: pack.shortDescription,
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
