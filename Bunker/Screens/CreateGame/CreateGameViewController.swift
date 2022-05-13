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
    private let createButton = PrimaryButton()
    private let logo = BunkerLogo()
    private let settings = UserSettings.shared
    
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
    
    private func updateUI() {
        let theme = settings.appearance
        createButton.setTheme(theme)
        logo.setTheme(theme)
        nameTextField.setTheme(theme)
        voteTimeTextField.setTheme(theme)
        packView.setTheme(theme)
        difficultyView.setTheme(theme)
    }
    
    private func setup() {
        if let username = UserSettings.shared.username {
            nameTextField.text = username
        }
        nameTextField.placeholder = "Введите имя"
        nameTextField.delegate = self
        
        voteTimeTextField.placeholder = "Введите время голосования (мин)"
        voteTimeTextField.delegate = self
        voteTimeTextField.keyboardType = .numberPad
        
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
        nameTextField.tag = 1
        voteTimeTextField.tag = 2
        
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
        createButton.setTitle("Создать игру", for: .normal)
        createButton.addTarget(self, action: #selector(createGame), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func handleTap() {
        nameTextField.resignFirstResponder()
        voteTimeTextField.resignFirstResponder()
    }
    
    @objc
    private func createGame() {
        
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension CreateGameViewController: UIGestureRecognizerDelegate { }


// MARK: - TextFieldDelegate
extension CreateGameViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            if let string = textField.text, string != "" {
                UserSettings.shared.username = string
            }
        case 2:
            return
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
