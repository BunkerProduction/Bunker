//
//  ButtonCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 16.06.2022.
//

import UIKit

final class ButtonCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ButtonCollectionViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 48).isActive = true

        self.layer.cornerRadius = 12

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    public func configure(_ title: String) {
        titleLabel.text = title
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
    }
}
