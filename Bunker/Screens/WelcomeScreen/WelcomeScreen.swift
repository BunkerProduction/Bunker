//
//  ViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class WelcomeController: UIViewController {
    private let settingsButton = UIButton()
    private let logo = BunkerLogo()
    public let instructionView = UIControl()
    private let createGameButton = PrimaryButton(frame: .zero)
    private let joinGameButton = PrimaryButton(frame: .zero)
    private var settings: UserSettings?
    private let instructionLabel = UILabel()
    private let instructionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bookIcon")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private var deepLink: DeepLink?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings = UserSettings.shared
        setupView()
        setupGameButtons()
        if let link = deepLink {
            let joinController = ConnectToGameViewController()
            joinController.deepLink = link
            self.navigationController?.pushViewController(joinController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        updateUI()
    }
    
    // MARK: - Update UI
    private func updateUI() {
        guard let theme = settings?.appearance else { return }
        createGameButton.setTheme(theme)
        joinGameButton.setTheme(theme)
        logo.setTheme(theme)
        settingsButton.backgroundColor = .Background.Accent.colorFor(theme)
        instructionView.backgroundColor = .Background.Accent.colorFor(theme)
        instructionLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        instructionIcon.tintColor = .TextAndIcons.Primary.colorFor(theme)
        
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
        navigationController?.navigationBar.barTintColor = .Background.LayerOne.colorFor(theme)
    }
    
    // MARK: - SetupView
    private func setupView() {
        createGameButton.setTitle("CREATE".localize(lan: settings?.language), for: .normal)
        joinGameButton.setTitle("JOIN".localize(lan: settings?.language), for: .normal)
        
        let buttonSV = UIStackView(arrangedSubviews: [joinGameButton, createGameButton])
        buttonSV.distribution = .fillEqually
        buttonSV.alignment = .fill
        buttonSV.axis = .vertical
        buttonSV.spacing = 16
        buttonSV.setHeight(to: 112)
        
        setupSettingsButton()
        setupInstructionView()
        
        let topSV = UIStackView(arrangedSubviews: [settingsButton, logo])
        topSV.distribution = .fill
        topSV.alignment = .center
        topSV.axis = .vertical
        topSV.spacing = 48
        
        let mainSV = UIStackView(arrangedSubviews: [topSV, instructionView, buttonSV])
        mainSV.distribution = .equalSpacing
        mainSV.alignment = .center
        mainSV.axis = .vertical
        
        self.view.addSubview(mainSV)
        mainSV.pin(to: view, [.left: 24, .right: 24])
        mainSV.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
        mainSV.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    private func setupSettingsButton() {
        settingsButton.setHeight(to: 48)
        settingsButton.pinWidth(to: settingsButton.heightAnchor, 1)
        settingsButton.setTitle("⚙️", for: .normal)
        settingsButton.layer.cornerRadius = 12
        settingsButton.setHeight(to: 48)
        settingsButton.pinWidth(to: settingsButton.heightAnchor, 1)
        
        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
    }
    
    private func setupInstructionView() {
        instructionView.layer.cornerRadius = 12
        instructionLabel.text = "RULES".localize(lan: settings?.language)
        instructionLabel.font = .customFont.title
        instructionLabel.textAlignment = .center
        
        let sV = UIStackView(arrangedSubviews: [instructionLabel, instructionIcon])
        sV.distribution = .equalCentering
        sV.alignment = .fill
        sV.axis = .vertical
        sV.isUserInteractionEnabled = false
        
        instructionView.addSubview(sV)
        sV.pin(to: instructionView, [.top: 50, .bottom: 50, .left: 0, .right: 0])
        instructionView.setHeight(to: 280)
        instructionView.setWidth(to: 216)

//        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(instructionPressed))
//        gesture.numberOfTapsRequired = 1
//        instructionView.isUserInteractionEnabled = true
//        instructionView.addGestureRecognizer(gesture)

        instructionView.addTarget(self, action: #selector(instructionPressedTouchDown), for: .touchDown)
        instructionView.addTarget(self, action: #selector(instructionPressedTouchUp), for: .touchUpInside)
        instructionView.addTarget(self, action: #selector(instructionPressedTouchUp), for: .touchUpOutside)
    }
    
    private func setupGameButtons() {
        createGameButton.addTarget(self, action: #selector(createGameButtonTapped), for: .touchUpInside)
        joinGameButton.addTarget(self, action: #selector(joinGameButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func instructionPressedTouchDown() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.instructionView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: nil
        )
    }

    @objc
    private func instructionPressedTouchUp() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.instructionView.transform = CGAffineTransform.identity
            },
            completion: nil
        )
        
        let instructionControler = InstructionsViewController()
        instructionControler.modalPresentationStyle = .overCurrentContext
        self.present(instructionControler, animated: true, completion: nil)
    }

    @objc
    private func settingsPressed() {
        let settings = SettingsViewController()
        self.navigationController?.pushViewController(settings, animated: true)
    }
    
    @objc
    private func createGameButtonTapped() {
        let createController = CreateGameViewController()
        self.navigationController?.pushViewController(createController, animated: true)
    }
    
    @objc
    private func joinGameButtonTapped() {
        let joinController = ConnectToGameViewController()
        self.navigationController?.pushViewController(joinController, animated: true)
    }
}

extension WelcomeController {
    func handleDeepLink(link: DeepLink) {
        deepLink = link
    }
}
