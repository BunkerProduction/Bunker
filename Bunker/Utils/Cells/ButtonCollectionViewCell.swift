//
//  ButtonCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 16.06.2022.
//

import UIKit

final class ButtonCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ButtonCollectionViewCell"

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        
    }
}
