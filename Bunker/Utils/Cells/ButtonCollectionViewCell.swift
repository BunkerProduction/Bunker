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
        label.textAlignment = .center
        
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
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 48).isActive = true

        self.layer.cornerRadius = 12

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    public func configure(_ title: String) {
        titleLabel.text = title
    }

    public func setTheme(_ theme: Appearence, _ warning: Bool) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        titleLabel.textColor = warning ? .Main.Warning.colorFor(theme) : .TextAndIcons.Primary.colorFor(theme)
    }
}
