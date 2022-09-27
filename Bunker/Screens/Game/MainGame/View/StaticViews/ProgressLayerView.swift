//
//  ProgressLayerView.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 27.09.2022.
//

import UIKit

final class ProgressLayerView: UIView {
    private let progressingView = UIView()
    private var trailingConstraint: NSLayoutConstraint?
    private var progress: Double = 0

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = false
        setupUI()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let fullWidth = self.frame.width
        trailingConstraint?.constant = -(fullWidth * (1 - progress))
    }

    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(progressingView)
        progressingView.layer.opacity = 0.5
        progressingView.pin(to: self, [.left, .top, .bottom])
        trailingConstraint = progressingView.pinRight(to: self)
    }

    public func setTheme(theme: Appearence) {
        progressingView.backgroundColor = .PrimaryColors.colorFor(theme)
    }

    public func updateProgress(progress: Double, withAnimation: Bool = true) {
        let fullWidth = self.frame.width
        self.progress = progress
        if withAnimation {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.trailingConstraint?.constant = -(fullWidth * (1 - progress))
                self?.layoutIfNeeded()
            }
        } else {
            trailingConstraint?.constant = -(fullWidth * (1 - progress))
        }
    }
}
