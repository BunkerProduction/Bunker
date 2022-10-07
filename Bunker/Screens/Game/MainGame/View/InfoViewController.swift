//
//  InfoViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 07.10.2022.
//

import UIKit

final class InfoViewController: UIViewController {
    struct ViewModel {
        let title: String
        let button1: ButtonViewModel?
        let button2: ButtonViewModel?

        struct ButtonViewModel {
            let action: (() -> Void)?
            let title: String
        }
    }

    private let topButton = PrimaryButton()
    private let bottomButton = PrimaryButton()

    private let label = UILabel()


    private let settings = UserSettings.shared

    private var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .Background.LayerOne.colorFor(settings.appearance)


        [label, topButton, bottomButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        label.pinCenter(to: view)

        bottomButton.setTheme(settings.appearance)
        bottomButton.pinBottom(to: view.bottomAnchor, 20)
        bottomButton.pinCenter(to: view.centerXAnchor)
        bottomButton.tag = 0

        topButton.setTheme(settings.appearance)
        topButton.pinBottom(to: bottomButton.topAnchor, 20)
        topButton.pinCenter(to: view.centerXAnchor)
        topButton.tag = 1
    }

    public func configure(_ viewModel: ViewModel) {
        self.viewModel = viewModel

        label.text = viewModel.title

        topButton.setTitle(viewModel.button1?.title, for: .normal)
        topButton.isHidden = viewModel.button1 != nil ? false : true

        bottomButton.setTitle(viewModel.button2?.title, for: .normal)
        bottomButton.isHidden = viewModel.button2 != nil ? false : true
    }

    @objc private func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            viewModel?.button1?.action?()
        } else {
            viewModel?.button2?.action?()
        }
    }
}
