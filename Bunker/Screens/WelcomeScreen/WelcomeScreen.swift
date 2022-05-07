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
    private let createGameButton = YellowButton(frame: .zero)
    private let joinGameButton = YellowButton(frame: .zero)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupGameButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - SetupView
    private func setupView() {
        self.view.backgroundColor = .white
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
        topSV.spacing = 50
        
        let middleSV = UIStackView(arrangedSubviews: [topSV, instructionView])
        middleSV.distribution = .fill
        middleSV.alignment = .center
        middleSV.axis = .vertical
        middleSV.spacing = 70
        
        let mainSV = UIStackView(arrangedSubviews: [middleSV, buttonSV])
        mainSV.distribution = .equalSpacing
        mainSV.alignment = .fill
        mainSV.axis = .vertical
        mainSV.spacing = 80
        
        self.view.addSubview(mainSV)
        mainSV.pin(to: view, [.left: 24, .right: 24, .bottom: 58])
        mainSV.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    private func setupSettingsButton() {
        settingsButton.backgroundColor = .Background.accent
        settingsButton.setHeight(to: 48)
        settingsButton.pinWidth(to: settingsButton.heightAnchor, 1)
        settingsButton.layer.cornerRadius = 12
        
        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
    }
    
    private func setupInstructionView() {
        instructionView.backgroundColor = .Background.accent
        instructionView.layer.cornerRadius = 12
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
