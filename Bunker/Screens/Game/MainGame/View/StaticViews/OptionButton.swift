//
//  OptionButton.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 25.09.2022.
//

import UIKit

final class OptionButton: UIControl {
    private let circleView = UIView()
    private let tapRecognizer = UITapGestureRecognizer()
    private var isChosen: Bool = false
    public var selectedColor: UIColor?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.height / 2
        circleView.layer.cornerRadius = (self.frame.height - 10) / 2
    }

    // MARK: - setup UI
    private func setupUI() {
        self.pinHeight(to: self.widthAnchor)

        addSubview(circleView)

        circleView.pin(to: self, [.left: 5, .right: 5, .top: 5, .bottom: 5])
        circleView.isHidden = true

        tapRecognizer.addTarget(self, action: #selector(buttonTapped))
        self.addGestureRecognizer(tapRecognizer)
        self.isUserInteractionEnabled = true
    }

    @objc
    private func buttonTapped() {
        if !isChosen {
            isChosen = true
            circleView.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
                self.circleView.backgroundColor = self.selectedColor
            }
            sendActions(for: .touchUpInside)
        }
    }
}
