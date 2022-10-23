//
//  DebugTableViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.10.2022.
//

import UIKit

final class DebugTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DebugTableViewCell"
    private let label = CopyableLabel()

    public var isShowingExplicit: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        self.selectionStyle = .none
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        label.numberOfLines = 0
        self.contentView.addSubview(label)

        label.pin(to: contentView, [.left: 10, .right: 10, .top: 10, .bottom: 10])
    }

    public func configure(text: String) {
        label.text = text
        label.textColor = .white
    }
}
