//
//  GameSpecialCardView.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 29.07.2022.
//

import UIKit

final class GameSpecialCardView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = UIButton()

    private var action: (() -> Void)?

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
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, actionButton])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8

        addSubview(stackView)
        stackView.pin(to: self, [.left: 12, .right: 12, .top: 12, .bottom: 12])
    }

    // MARK: - UpdateUI
    public func setTheme(_ theme: Appearence) {
        backgroundColor = .Background.Accent.colorFor(theme)
    }

    @objc
    private func actionButtonTapped() {
        action?()
    }

    public func configure(_ title: String,_ subtitle: String, action: (() -> Void)?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        self.action = action
    }
}
