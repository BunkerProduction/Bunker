//
//  PlayerCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.07.2022.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PlayerCollectionViewCell"

    private let nameLabel = UILabel()
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left

        return label
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

        let stackView = UIStackView(arrangedSubviews: [leftView, nameLabel, attributeLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        addSubview(nameLabel)
        nameLabel.pin(to: self, [.left: 12, .top: 12, .bottom: 12])
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
    }

    public func configure(name: String) {
        nameLabel.text = name
        attributeLabel.text = "😡 😎"
    }
}
