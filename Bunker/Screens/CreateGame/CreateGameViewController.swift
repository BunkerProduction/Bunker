//
//  CreateGameViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class CreateGameViewController: UIViewController {
    private let nameTextField = BunkerTextField()
    private let voteTimeTextField = BunkerTextField()
    private let packView = GameOptionView()
    private let difficultyView = GameOptionView()
    private let createButton = YellowButton()
    private let logo = BunkerLogo()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isMultipleTouchEnabled = true

        return scrollView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        setOptions()
        setButton()
        setupView()
    }
    
    private func setOptions() {
        packView.setLabels("Набор", "Случайный", "🎲")
        difficultyView.setLabels("Набор", "Случайный", "🎲")
    }
    
    // MARK: - View setup
    private func setupView() {
        let textSV = UIStackView(arrangedSubviews: [nameTextField, voteTimeTextField])
        textSV.distribution = .fillEqually
        textSV.alignment = .fill
        textSV.axis = .vertical
        textSV.spacing = 16
        
        let optionsSV = UIStackView(arrangedSubviews: [packView, difficultyView])
        optionsSV.distribution = .fillEqually
        optionsSV.alignment = .fill
        optionsSV.axis = .horizontal
        optionsSV.spacing = 16
        
        let focusSV = UIStackView(arrangedSubviews: [textSV, optionsSV])
        focusSV.distribution = .fill
        focusSV.alignment = .fill
        focusSV.axis = .vertical
        focusSV.spacing = 16
        
        let mainSV = UIStackView(arrangedSubviews: [focusSV, createButton])
        mainSV.distribution = .equalSpacing
        mainSV.alignment = .fill
        mainSV.axis = .vertical
//        mainSV.spacing = 189
        
        self.view.addSubview(logo)
        logo.pinCenter(to: view.centerXAnchor)
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 60)
        
        self.view.addSubview(mainSV)
        mainSV.pin(to: view, [.left: 24, .right: 24, .bottom: 58])
        mainSV.pinTop(to: logo.bottomAnchor, 50)
    }
    
    private func setButton() {
        createButton.setHeight(to: 48)
        createButton.setTitle("Создать игру", for: .normal)
        createButton.addTarget(self, action: #selector(createGame), for: .touchUpInside)
    }
    
    @objc
    private func createGame() {
        
    }
}
