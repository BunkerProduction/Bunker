//
//  GameOptionView.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class GameOptionView: UIButton {
    private let typeLabel = UILabel()
    private let chosenLabel = UILabel()
    private let emoji = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.setHeight(to: 154)
        self.pinWidth(to: self.heightAnchor, 1)
        
        let stackView = UIStackView(arrangedSubviews: [typeLabel, chosenLabel, emoji])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
        self.addSubview(stackView)
        stackView.pin(to: self, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }
    
    public func setLabels(_ type: String,_ chosen: String,_ emoji: String) {
        self.typeLabel.text = type
        self.chosenLabel.text = chosen
        self.emoji.text = emoji
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        self.typeLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
        self.typeLabel.font = .customFont.caption
        self.chosenLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        self.chosenLabel.font = .customFont.body
        self.emoji.font = .customFont.icon
    }
}
