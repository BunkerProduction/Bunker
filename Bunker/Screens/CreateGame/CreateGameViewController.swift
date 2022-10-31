//
//  CreateGameViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit
import Combine

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
    private var viewModel: CreateGameViewModel?
    private let settings = UserSettings.shared
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = CreateGameViewModel(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

        view.isUserInteractionEnabled = true
        viewModel?.viewWillAppear()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        handleTap()
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
        nameTextField.placeholder = "ENTER_NAME".localize(lan: settings.language)
        nameTextField.delegate = self
        voteTimeTextField.placeholder = "ENTER_VOTING".localize(lan: settings.language)
        voteTimeTextField.delegate = self
        voteTimeTextField.keyboardType = .numberPad
        voteTimeTextField.isHidden = true
        voteTimeTextField.addDoneButtonOnKeyboard()
        
        setOptions()
        setButton()
        setupView()
    }
    
    private func setOptions() {
        packView.addTarget(self, action: #selector(choosePack), for: .touchUpInside)
        difficultyView.setLabels(
            "PACK".localize(lan: settings.language),
            "RANDOM".localize(lan: settings.language),
            "🎲"
        )
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
        createButton.isEnabled = false
        createButton.setTitle("CREATE_GAME".localize(lan: settings.language), for: .normal)
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
        self.viewModel?.choosePack()
    }
    
    @objc
    private func createGame() {
        view.isUserInteractionEnabled = false
        createButton.isLoading = true
        viewModel?.createGame()
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func setScreenData(username: String, prefs: GamePreferences, _ buttonEnabled: Bool) {
        nameTextField.text = username
        if let catastrophy = prefs.catastrophe {
            packView.setLabels(
                "PACK".localize(lan: settings.language),
                catastrophy.name,
                catastrophy.icon
            )
        }
        if let difficulty = prefs.difficulty {
            difficultyView.setLabels(
                "DIFFICULTY".localize(lan: settings.language),
                "CLASSIC".localize(lan: settings.language),
                "😯"
            )
        }
        createButton.isEnabled = buttonEnabled
    }

    public func navigate(vc: UIViewController) {
        createButton.isLoading = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TextFieldDelegate
extension CreateGameViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            if textField.text != "" {
                createButton.isEnabled = true
            } else {
                createButton.isEnabled = false
            }
        case 2:
            if textField.text != "" {

            }
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            if let string = textField.text {
                viewModel?.username = string
            }
        case 2:
            if let string = textField.text {
//                viewModel?.votingTime = 1
            }
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

