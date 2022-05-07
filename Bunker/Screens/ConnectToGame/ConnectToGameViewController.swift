//
//  ConnectToGameViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class ConnectToGameViewController: UIViewController {
    private let nameTextField = BunkerTextField()
    private let logo = BunkerLogo()
    private let nextButton = YellowButton()
    
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
        
        view.addSubview(nameTextField)
        nameTextField.pin(to: view, [.left: 24, .right: 24])
        nameTextField.pinTop(to: logo.bottomAnchor, 46)
    }
    
    private func setButton() {
        view.addSubview(nextButton)
        
        nextButton.pin(to: view, [.left: 24, .right: 24, .bottom: 58])
        nextButton.setTitle("Далее", for: .normal)
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func goNext() {
        let enterRoomController = RoomCodeViewController()
        self.navigationController?.pushViewController(enterRoomController, animated: true)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension ConnectToGameViewController: UIGestureRecognizerDelegate { }
