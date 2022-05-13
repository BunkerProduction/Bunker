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
    private let nextButton = PrimaryButton()
    private let settings = UserSettings.shared
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    // MARK: - update UI
    private func updateUI() {
        let theme = settings.appearance
        nextButton.setTheme(theme)
        logo.setTheme(theme)
        nameTextField.setTheme(theme)
        
        self.view.backgroundColor = .white
    }
    
    // MARK: - UI setup
    private func setup() {
        if let username = UserSettings.shared.username {
            nameTextField.text = username
        }
        nameTextField.placeholder = "Введите имя"
        nameTextField.delegate = self
        
        setButton()
        setupView()
    }
    
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
    private func handleTap() {
        nameTextField.resignFirstResponder()
    }
    
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

extension ConnectToGameViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let string = textField.text, string != "" {
            UserSettings.shared.username = string
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        goNext()
        
        return false
    }
}
