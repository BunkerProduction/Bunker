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
        contentView.addSubview(titleLabel)
    }

    public func configure(_ title: String) {
        titleLabel.text = title
    }
}
