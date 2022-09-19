//
//  InstructionCollectionViewCell.swift
//  Bunker
//
//  Created by Danila Kokin on 17.09.2022.
//

import UIKit

final class InstructionCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "InstructionCollectionViewCell"
    private var pageSV = UIStackView()
    private var headlineLabel = UILabel()
    private var sectionSV = UIStackView()


    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        pageSV.axis = .vertical
        pageSV.spacing = 8
        pageSV.alignment = .leading

        self.contentView.addSubview(pageSV)

        pageSV.translatesAutoresizingMaskIntoConstraints = false
        pageSV.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24).isActive = true
        pageSV.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24).isActive = true
        pageSV.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true

    }

    private func configureHeadlineLabel(_ headline: String?) {
        if headline != nil {
            headlineLabel.text = headline
            headlineLabel.font = .customFont.headline

            pageSV.addArrangedSubview(headlineLabel)
        }
    }

    private func configureSectionsStackView(_ sections: [InstructionSection]) {
        sectionSV.axis = .vertical
        sectionSV.spacing = 8
        sectionSV.alignment = .leading

        for section in sections {
            let section = InstructionSectionView(section: section)

            sectionSV.addArrangedSubview(section)
        }
        pageSV.addArrangedSubview(sectionSV)
    }

    public func configure(_ screen: InstructionScreen) {
        pageSV.subviews.forEach { $0.removeFromSuperview() }
        sectionSV.subviews.forEach { $0.removeFromSuperview() }
        configureHeadlineLabel(screen.headline)
        configureSectionsStackView(screen.sections)
        setupView()
    }
}
