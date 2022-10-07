//
//  InstructionSectionView.swift
//  Bunker
//
//  Created by Danila Kokin on 18.09.2022.
//

import UIKit

final class InstructionSectionView: UIStackView {
    private let settings: UserSettings
    private var section: InstructionSection
    private var titleLabel = UILabel()
    private var sectionSV = UIStackView()

    //MARK: Init
    init(section: InstructionSection, _ settings: UserSettings) {
        self.section = section
        self.settings = settings
        super.init(frame: .zero)

        setupView()
    }

    @available (*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.axis = .vertical
        self.spacing = 8
        self.alignment = .leading
        
        configureTitleLabel()
        configureSectionStackView()
    }

    private func configureTitleLabel() {
        if section.title != nil {
            let theme = settings.appearance

            titleLabel.text = section.title
            titleLabel.font = .customFont.title
            titleLabel.textColor = .TextAndIcons.Primary.colorFor(theme)

            self.addArrangedSubview(titleLabel)
        }
    }

    private func configureSectionStackView() {
        sectionSV.axis = .vertical
        sectionSV.spacing = 10
        sectionSV.alignment = .leading

        let theme = settings.appearance

        for block in section.blocks {
            let subtitleLabel = UILabel()
            let descriptionLabel = UILabel()

            subtitleLabel.text = block.subtitle
            subtitleLabel.font = .customFont.body
            subtitleLabel.textColor = .TextAndIcons.Primary.colorFor(theme)

            descriptionLabel.setCustomAttributedText(
                string: block.text,
                font: .customFont.footnote ?? .systemFont(ofSize: 14, weight: .regular),
                1.25
            )
            descriptionLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
            descriptionLabel.numberOfLines = 0

            let blockSV = UIStackView(arrangedSubviews: [subtitleLabel, descriptionLabel])
            blockSV.axis = .vertical
            blockSV.spacing = 2
            blockSV.alignment = .leading

            sectionSV.addArrangedSubview(blockSV)
        }
        self.addArrangedSubview(sectionSV)
    }
}
