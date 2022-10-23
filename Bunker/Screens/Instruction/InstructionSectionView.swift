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
        self.spacing = 4
        self.alignment = .leading
        
        configureTitleLabel()
        configureSectionSV()
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

    private func configureSectionSV() {
        sectionSV.axis = .vertical
        sectionSV.spacing = 8
        sectionSV.alignment = .leading

        let theme = settings.appearance

        for block in section.blocks {
            let blockSV = UIStackView()
            blockSV.axis = .vertical
            blockSV.alignment = .leading

            if let subtitle = block.subtitle {
                let subtitleLabel = UILabel()
                subtitleLabel.text = subtitle
                subtitleLabel.font = .customFont.body
                subtitleLabel.textColor = .TextAndIcons.Primary.colorFor(theme)

                blockSV.addArrangedSubview(subtitleLabel)
            }

            let textSV = UIStackView()
            textSV.axis = .vertical
            textSV.spacing = 4
            textSV.alignment = .leading

            for text in block.text {
                let textLabel = UILabel()
                textLabel.numberOfLines = 0
                textLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
                textLabel.setCustomAttributedText(
                    string: text,
                    font: .customFont.footnote ?? .systemFont(ofSize: 14, weight: .regular),
                    1.25
                )
                textSV.addArrangedSubview(textLabel)
            }

            blockSV.addArrangedSubview(textSV)
            sectionSV.addArrangedSubview(blockSV)
        }
        self.addArrangedSubview(sectionSV)
    }
}
