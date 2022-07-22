//
//  PlayerCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.07.2022.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PlayerCollectionViewCell"

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

    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
    }
}
