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

    public var deepLink: DeepLink?
    
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

        if let deepLink = deepLink {
            switch deepLink {
            case .join(let code):
                // TODO: - Put it to viewModel and validate code?
                let enterRoomController = RoomCodeViewController(code: code)
                self.navigationController?.pushViewController(enterRoomController, animated: true)
            }
        }
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
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.TextAndIcons.Primary.colorFor(theme)
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
    }
    
    // MARK: - UI setup
    private func setup() {
        if let username = UserSettings.shared.username {
            nameTextField.text = username
        }
        nameTextField.placeholder = "Enter name"
        nameTextField.delegate = self
        
        setButton()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(logo)
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 48)
        logo.pinCenter(to: view.centerXAnchor)
        
        view.addSubview(nameTextField)
        nameTextField.pin(to: view, [.left: 24, .right: 24])
        nameTextField.pinTop(to: logo.bottomAnchor, 46)
    }
    
    private func setButton() {
        view.addSubview(nextButton)
        
        nextButton.pin(to: view, [.left: 24, .right: 24])
        nextButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func handleTap() {
        nameTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    @objc
    private func goNext() {
        if nameTextField.text == "" {
            UIView.animate(withDuration: 0.2) {
                self.nameTextField.layer.borderWidth = 2
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.nameTextField.layer.borderWidth = 0
            }
            let enterRoomController = RoomCodeViewController()
            self.navigationController?.pushViewController(enterRoomController, animated: true)
        }
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension ConnectToGameViewController: UIGestureRecognizerDelegate { }

// MARK: - TextField Delegate
extension ConnectToGameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            UIView.animate(withDuration: 0.1) {
                self.nameTextField.layer.borderWidth = 2
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.nameTextField.layer.borderWidth = 0
            }
        }
    }

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
