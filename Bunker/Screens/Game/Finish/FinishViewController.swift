//
//  FinishViewController.swift
//  Bunker
//
//  Created by Danila Kokin on 08.10.2022.
//

import UIKit

final class FinishViewController: UIViewController {
    private let coordinator: GameCoordinator?

    private enum Consts {
        static let spacing: Double = 8
        static let topInset: Double = 96
        static let edgeInset: Double = 24
        static let imageSize: Double = 140
        static let interInset: Double = 16
        static let cornerRadius: CGFloat = 8
        static let buttonHeight: Double = 48
        static let iconConfig = UIImage.SymbolConfiguration(weight: .bold)
    }
    private let settings = UserSettings.shared
    private let backgroundView = UIView()
    private let iconView = UIImageView()
    private let textLabel = UILabel()
    private let stayButton = UIButton()
    private let menuButton = UIButton()

    // MARK: - Init
    init(_ coordinator: GameCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupView()
        updateUI()
    }

    private func setupView() {
        setupLabel()
        setupIcon()

        let textAndIconSV = UIStackView(arrangedSubviews: [iconView, textLabel])
        textAndIconSV.axis = .vertical
        textAndIconSV.alignment = .center
        textAndIconSV.spacing = Consts.spacing

        backgroundView.addSubview(textAndIconSV)
        textAndIconSV.pin(to: backgroundView, [.left: Consts.interInset, .top: Consts.interInset, .right: Consts.interInset, .bottom: Consts.interInset])
        backgroundView.layer.cornerRadius = Consts.cornerRadius

        view.addSubview(backgroundView)
        backgroundView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Consts.topInset)
        backgroundView.pin(to: view, [.left: Consts.edgeInset, .right: Consts.edgeInset])

        setupMenuButton()
        setupStayButton()
    }

    private func setupIcon() {
        iconView.setWidth(to: Consts.imageSize)
        iconView.setHeight(to: Consts.imageSize)
    }

    private func setupLabel() {
        textLabel.font = .customFont.body
        textLabel.textAlignment = .center
    }

    private func updateUI() {
        let theme = settings.appearance
        view.backgroundColor = .Main.Primary.colorFor(theme)
        textLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        backgroundView.backgroundColor = .Background.Accent.colorFor(theme)
        menuButton.setTitleColor(.TextAndIcons.Primary.colorFor(theme), for: .normal)
        menuButton.backgroundColor = .Background.Accent.colorFor(theme)
        stayButton.setTitleColor(.TextAndIcons.Primary.colorFor(theme), for: .normal)
        stayButton.backgroundColor = .Background.Accent.colorFor(theme)
    }

    private func setupStayButton() {
        view.addSubview(stayButton)
        stayButton.setTitle("Остаться наблюдателем", for: .normal)
        stayButton.titleLabel?.font = .customFont.body
        stayButton.layer.cornerRadius = Consts.cornerRadius
        stayButton.setHeight(to: Consts.buttonHeight)
        stayButton.pin(to: view, [.left: Consts.edgeInset, .right: Consts.edgeInset])
        stayButton.pinBottom(to: menuButton.topAnchor, Consts.interInset)

        stayButton.addTarget(self, action: #selector(navigateToGame), for: .touchUpInside)
    }

    private func setupMenuButton() {
        view.addSubview(menuButton)
        menuButton.setTitle("В главное меню", for: .normal)
        menuButton.titleLabel?.font = .customFont.body
        menuButton.layer.cornerRadius = Consts.cornerRadius
        menuButton.setHeight(to: Consts.buttonHeight)
        menuButton.pin(to: view, [.left: Consts.edgeInset, .right: Consts.edgeInset])
        menuButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Consts.interInset)

        menuButton.addTarget(self, action: #selector(navigateToMenu), for: .touchUpInside)
    }

    @objc
    func navigateToGame() {
        self.dismiss(animated: true)
    }

    @objc
    func navigateToMenu() {
        self.dismiss(animated: false)
        coordinator?.exitGame()
    }

    public func configure(_ mode: FinishMode) {
        switch mode {
        case .won:
            iconView.image = UIImage(named: "win")?.withTintColor(.blue)
            textLabel.text = "Поздравляю! \nВы остались в бункере до конца\nи выжили."
            stayButton.isHidden = true
        case .lost:
            iconView.image = UIImage(named: "lose")?.withTintColor(.blue)
            textLabel.text = "Вы выбыли из бункера.\nМожете остаться наблюдателем\nили покинуть комнату."
            stayButton.isHidden = false
        }
    }
}


public enum FinishMode {
    case won
    case lost
}
