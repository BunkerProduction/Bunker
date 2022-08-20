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
    }

    // MARK: - UpdateUI
    public func setTheme(_ theme: Appearence) {
        backgroundColor = .Background.Accent.colorFor(theme)
    }

    public func configure(_ viewModel: ViewModel) {

    }
}

