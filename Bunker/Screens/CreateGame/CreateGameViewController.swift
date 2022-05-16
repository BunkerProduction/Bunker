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
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isMultipleTouchEnabled = true

        return scrollView
    }()
    
    private var gamePref = GamePreferences()
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
    
    // MARK: - UpdateUI
    private func updateUI() {
        let theme = settings.appearance
        createButton.setTheme(theme)
        logo.setTheme(theme)
        nameTextField.setTheme(theme)
        voteTimeTextField.setTheme(theme)
        packView.setTheme(theme)
        difficultyView.setTheme(theme)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.TextAndIcons.Primary.colorFor(theme)
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
    }
    
    private func setup() {
        if let username = UserSettings.shared.username {
            nameTextField.text = username
        }
        nameTextField.placeholder = "Enter name"
        nameTextField.delegate = self
        voteTimeTextField.placeholder = "Enter voting time (1-20 min)"
        voteTimeTextField.delegate = self
        voteTimeTextField.keyboardType = .numberPad
        
        setOptions()
        setButton()
        setupView()
    }
    
    private func setOptions() {
        let catastrophe = gamePref.catastrophe
        packView.setLabels("Pack", catastrophe?.name ?? "Random", catastrophe?.icon ?? "🎲")
        packView.addTarget(self, action: #selector(choosePack), for: .touchUpInside)
        difficultyView.setLabels("Pack", "Random", "🎲")
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
        
        self.view.addSubview(logo)
        logo.pinCenter(to: view.centerXAnchor)
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 48)
        
        self.view.addSubview(mainSV)
        mainSV.pin(to: view, [.left: 24, .right: 24])
        mainSV.pinTop(to: logo.bottomAnchor, 50)
        mainSV.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
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
    private func choosePack() {
        let packVC = PackViewController()
        if let pack = gamePref.catastrophe {
            packVC.chosenPack = pack
        }
        packVC.delegate = self
        self.navigationController?.pushViewController(packVC, animated: true)
    }
    
    @objc
    private func createGame() {
        let waitingRoomVC = WaitingRoomViewController()
        self.navigationController?.pushViewController(waitingRoomVC, animated: true)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

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

// MARK: - GestureDelegate
extension CreateGameViewController: UIGestureRecognizerDelegate { }

// MARK: - PackDelegate
extension CreateGameViewController: PackViewControllerDelegate {
    func packSet(_ pack: Catastrophe) {
        self.gamePref.catastrophe = pack
        setOptions()
    }
}
