//
//  GameHeaderView.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.07.2022.
//

import UIKit

final class GameHeaderView: UIView {
    struct ViewModel {
        enum HeaderMode {
            case normal(text: String)
            case voting
        }

        let mode: HeaderMode
    }

    private var settings = UserSettings.shared
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0

        return view
    }()
    private let title: UILabel = {
        let label = UILabel()
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont.body

        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup
    private func setupView() {
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(subtitleLabel)
        subtitleLabel.pin(to: backgroundView, [.left: 8, .right: 8, .top: 8, .bottom: 8])


        let stackView = UIStackView(arrangedSubviews: [title, backgroundView])
        stackView.axis = .vertical
        stackView.distribution = .fill

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.pin(to: self, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }

    // MARK: - UpdateUI
    public func setTheme(_ theme: Appearence) {
        title.textColor = .TextAndIcons.Primary.colorFor(theme)
        subtitleLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
        backgroundColor = .Background.Accent.colorFor(theme)
        backgroundView.layer.borderColor = UIColor.PrimaryColors.colorFor(theme)?.cgColor
    }

    public func configure(_ viewModel: ViewModel) {
        switch viewModel.mode {
            case .normal(let text):
                subtitleLabel.text = text
                title.isHidden = true
            case .voting:
            subtitleLabel.text = "CHOOSE_WHOM_TO_EXCLUDE".localize(lan: settings.language)
                title.isHidden = false
        }
    }
}

