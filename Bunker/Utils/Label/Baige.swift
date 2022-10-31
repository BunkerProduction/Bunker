//
//  Baige.swift
//  Bunker
//
//  Created by Danila Kokin on 17.05.2022.
//

import UIKit

final class BaigeView: UIView {
    private var settings = UserSettings.shared
    private let baigeLabel = UILabel()
    enum Label {
        case soon
        case premium
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(label: Label) {
        self.init()

        switch label {
        case .soon:
            baigeLabel.text = "SOOM".localize(lan: settings.language)
        case .premium:
            baigeLabel.text = "PREMIUM".localize(lan: settings.language)
        }
    }

    private func setupView() {
        baigeLabel.font = .customFont.baige
        baigeLabel.textAlignment = .center
        self.addSubview(baigeLabel)
        baigeLabel.pin(to: self, [.left: 10, .right: 10])
        baigeLabel.pinCenter(to: self.centerYAnchor)
        self.setHeight(to: 20)

        self.layer.cornerRadius = 10
        self.layer.cornerCurve = .continuous
        self.layer.borderWidth = 2
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.Main.Primary.colorFor(theme)?.cgColor
        self.baigeLabel.textColor = .Main.Primary.colorFor(theme)
    }
}
