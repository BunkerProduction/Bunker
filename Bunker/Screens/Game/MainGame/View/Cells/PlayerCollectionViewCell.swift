//
//  PlayerCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.07.2022.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PlayerCollectionViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left

        return label
    }()
    private let attributeLabels: [UILabel] = {
        let emojiLabel1 = UILabel()
        let emojiLabel2 = UILabel()
        let emojiLabel3 = UILabel()
        let emojiLabel4 = UILabel()
        let emojiLabel5 = UILabel()
        let emojiLabel6 = UILabel()

        return [emojiLabel1, emojiLabel2, emojiLabel3, emojiLabel4, emojiLabel5, emojiLabel6]
    }()
    private let leftView = OptionButton()
    private let progressView = ProgressLayerView()
    public var progressCache: ProgressCache?

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
        self.layer.cornerRadius = 12

        let attributeStackView = UIStackView(arrangedSubviews: attributeLabels)
        attributeStackView.axis = .horizontal
        attributeStackView.distribution = .equalSpacing
        attributeStackView.spacing = 4
        attributeStackView.alignment = .trailing
        
        attributeStackView.setWidth(to: 180)

        let stackView = UIStackView(arrangedSubviews: [leftView, nameLabel, attributeStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        contentView.addSubview(progressView)
        stackView.pin(to: self, [.left: 12, .right: 12, .top: 12, .bottom: 12])
        progressView.pin(to: self)
        progressView.isHidden = true
        self.clipsToBounds = true
    }

    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        nameLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        leftView.selectedColor = .PrimaryColors.colorFor(theme)
        leftView.backgroundColor = .Background.LayerTwo.colorFor(theme)
        progressView.setTheme(theme: theme)
        self.layer.borderColor = UIColor.PrimaryColors.colorFor(theme)?.cgColor
    }

    public func configure(player: Player, mode: GameState = .normal, votingProgress: Double) {
        nameLabel.text = player.username

        for attrIndex in player.attributes.indices {
            attributeLabels[attrIndex].text = "\(player.attributes[attrIndex].icon)"
            attributeLabels[attrIndex].font = .customFont.icon
            attributeLabels[attrIndex].alpha = 1

            if !player.attributes[attrIndex].isExposed {
                attributeLabels[attrIndex].alpha = 0
            }
        }

        switch mode {
            case .normal:
                leftView.isUserInteractionEnabled = true
                leftView.isHidden = true
                progressView.isHidden = true
//                applayVotesProgress(progress: votingProgress, identifier: player.UID)
            case .voting:
                leftView.isUserInteractionEnabled = true
                leftView.isHidden = false
                progressView.isHidden = false
                applayVotesProgress(progress: votingProgress, identifier: player.UID)
        }
    }

    private func applayVotesProgress(progress: Double, identifier: String) {
        self.layer.borderWidth = 2

        let oldProgress = progressCache?.getProgress(for: identifier) ?? 0
        progressView.updateProgress(progress: oldProgress, withAnimation: false)
        progressView.updateProgress(progress: progress)
    }
}
