//
//  RoomCodeViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class RoomCodeViewController: UIViewController {
    private let logo = BunkerLogo()
    private let codeInput = SplittedDigitInput()
    private let connectButton = YellowButton()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setButton()
        setupView()
    }
    
    // MARK: - UI setup
    private func setupView() {
        view.addSubview(logo)
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 60)
        logo.pinCenter(to: view.centerXAnchor)
        
        view.addSubview(codeInput)
        codeInput.pin(to: view, [.left: 24, .right: 24])
        codeInput.pinTop(to: logo.bottomAnchor, 46)
        codeInput.setHeight(to: 105)
    }
    
    private func setButton() {
        view.addSubview(connectButton)
        
        connectButton.pin(to: view, [.left: 24, .right: 24, .bottom: 58])
        connectButton.setTitle("Присоединиться", for: .normal)
        connectButton.addTarget(self, action: #selector(joinGame), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func joinGame() {
        codeInput.toggleInput(true)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension RoomCodeViewController: UIGestureRecognizerDelegate { }
