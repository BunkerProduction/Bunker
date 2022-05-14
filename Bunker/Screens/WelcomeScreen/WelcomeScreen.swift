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
    private let instructionView = UIView()
    private let createGameButton = PrimaryButton(frame: .zero)
    private let joinGameButton = PrimaryButton(frame: .zero)
    private let settings = UserSettings.shared
    private let instructionLabel = UILabel()
    private let instructionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bookIcon")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupGameButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        updateUI()
    }
    
    // MARK: - Update UI
    private func updateUI() {
        let theme = settings.appearance
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
        createGameButton.setTitle("Создать игру", for: .normal)
        joinGameButton.setTitle("Присоединиться к игре", for: .normal)
        
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
//        mainSV.spacing = 80
        
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
        instructionLabel.text = "Правила игры"
        instructionLabel.font = .customFont.title
        instructionLabel.textAlignment = .center
        let sV = UIStackView(arrangedSubviews: [instructionLabel, instructionIcon])
        sV.distribution = .equalCentering
        sV.alignment = .fill
        sV.axis = .vertical
        
        instructionView.addSubview(sV)
        sV.pin(to: instructionView, [.top: 50, .bottom: 50, .left: 0, .right: 0])
        instructionView.setHeight(to: 281)
        instructionView.setWidth(to: 215)
    }
    
    private func setupGameButtons() {
        createGameButton.addTarget(self, action: #selector(createGameButtonTapped), for: .touchUpInside)
        joinGameButton.addTarget(self, action: #selector(joinGameButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Interactions
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
