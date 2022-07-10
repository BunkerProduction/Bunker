//
//  ConditionCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 11.07.2022.
//

import UIKit

final class ConditionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ConditionCollectionViewCell"

    private let iconLabel = UILabel()
    private let typeLabel = UILabel()
    private let descriptionLabel = UILabel()

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

        let stackView = UIStackView(arrangedSubviews: [iconLabel, typeLabel])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal

        let mainSV = UIStackView(arrangedSubviews: [stackView, descriptionLabel])
        mainSV.distribution = .fill
        mainSV.alignment = .fill
        mainSV.axis = .vertical
        mainSV.spacing = 8

        self.addSubview(mainSV)
        mainSV.pin(to: self, [.left: 12, .right: 12, .top: 12, .bottom: 12])
    }

    public func configure() {
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
    }
}
