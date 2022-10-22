//
//  DebagView.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.10.2022.
//

import UIKit

final class DebagView: UIView {
    private let imageView = UIImageView(image: UIImage(systemName: "ladybug.fill"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        self.translatesAutoresizingMaskIntoConstraints = false

        imageView.pin(to: self, [.left: 10, .right: 10, .top: 10, .bottom: 10])
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 50.0),
            self.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        self.layer.cornerRadius = 25
        self.backgroundColor = UIColor(white: 0.9, alpha: 0.3)

        let tapG = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapG)
    }

    @objc private func viewTapped() {
        let vc = DebagViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)

        if let rootVC = self.window?.rootViewController {
            self.isHidden = true
            rootVC.modalPresentationStyle = .fullScreen
            rootVC.present(navVC, animated: true)
        }
    }
}

extension DebagView: DebagViewControllerDelegate {
    func didDisappear() {
        self.isHidden = false
    }
}
