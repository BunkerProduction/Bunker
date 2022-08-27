//
//  PlayerCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.07.2022.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PlayerCollectionViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left

        return label
    }()
    private let attributeLabels: [UILabel] = {
        let emojiLabel1 = UILabel()
        let emojiLabel2 = UILabel()
        let emojiLabel3 = UILabel()
        let emojiLabel4 = UILabel()
        let emojiLabel5 = UILabel()
        let emojiLabel6 = UILabel()

        return [emojiLabel1, emojiLabel2, emojiLabel3, emojiLabel4, emojiLabel5, emojiLabel6]
    }()
    private let leftView = UIView()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        self.layer.cornerRadius = 12

        let attributeStackView = UIStackView(arrangedSubviews: attributeLabels)
        attributeStackView.axis = .horizontal
        attributeStackView.distribution = .equalSpacing
        attributeStackView.spacing = 4
        attributeStackView.alignment = .trailing
        
        attributeStackView.setWidth(to: 180)

        let stackView = UIStackView(arrangedSubviews: [leftView, nameLabel, attributeStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        addSubview(stackView)
        stackView.pin(to: self, [.left: 12, .right: 12, .top: 12, .bottom: 12])
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        nameLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
    }

    public func configure(player: Player) {
        nameLabel.text = player.username

        for attrIndex in player.attributes.indices {
            attributeLabels[attrIndex].text = "\(player.attributes[attrIndex].icon)"
            attributeLabels[attrIndex].font = .customFont.icon
            attributeLabels[attrIndex].alpha = 1

            if !player.attributes[attrIndex].isExposed {
                attributeLabels[attrIndex].alpha = 0
            }

        }
        leftView.isHidden = true
    }
}
