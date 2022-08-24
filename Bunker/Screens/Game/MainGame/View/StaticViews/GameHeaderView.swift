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

    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8

        return view
    }()
    private let title: UILabel = {
        let label = UILabel()
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont.footnote

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
        self.layer.cornerRadius = 12

        backgroundView.addSubview(subtitleLabel)
        subtitleLabel.pin(to: backgroundView, [.left: 6, .right: 6, .top: 6, .bottom: 6])


        let stackView = UIStackView(arrangedSubviews: [title, backgroundView])
        stackView.axis = .vertical
        stackView.distribution = .fill

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.pin(to: self, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }

    // MARK: - UpdateUI
    public func setTheme(_ theme: Appearence) {
        backgroundColor = .Background.Accent.colorFor(theme)
        backgroundView.backgroundColor = .Background.LayerTwo.colorFor(theme)
    }

    public func configure(_ viewModel: ViewModel) {
        switch viewModel.mode {
            case .normal(let text):
                subtitleLabel.text = text
                title.isHidden = true
            case .voting:
                title.isHidden = false
        }
    }
}

