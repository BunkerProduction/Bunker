//
//  IconCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "IconCollectionViewCell"
    
    private var iconName: String?
    private let imageView = UIImageView()
    
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
        self.layer.cornerRadius = 12
        
        self.contentView.addSubview(imageView)
        imageView.pin(to: contentView)
    }
    
    public func configure(iconName: String) {
        self.backgroundColor = .yellow
    }
}
