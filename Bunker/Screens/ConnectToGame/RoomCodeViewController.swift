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
    private let connectButton = PrimaryButton()
    private let settings = UserSettings.shared
    private lazy var viewModel = ConnectViewModel(self)


    // MARK: - Init
    init(code: String? = nil) {
        super.init(nibName: nil, bundle: nil)

        if let code = code {
            codeInput.setValues(code)
        }
    }

    @available (*, unavailable)
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
        
        setButton()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        viewModel.navigatedBack()
        updateUI()
    }
    
    private func updateUI() {
        let theme = settings.appearance
        connectButton.setTheme(theme)
        logo.setTheme(theme)
        codeInput.setTheme(theme)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.TextAndIcons.Primary.colorFor(theme)
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
    }
    
    // MARK: - UI setup
    private func setupView() {
        view.addSubview(logo)
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 48)
        logo.pinCenter(to: view.centerXAnchor)
        
        view.addSubview(codeInput)
        codeInput.pin(to: view, [.left: 24, .right: 24])
        codeInput.pinTop(to: logo.bottomAnchor, 46)
        codeInput.setHeight(to: 116)
    }
    
    private func setButton() {
        view.addSubview(connectButton)
        
        connectButton.pin(to: view, [.left: 24, .right: 24])
        connectButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
        connectButton.setTitle("Join", for: .normal)
        connectButton.addTarget(self, action: #selector(joinGame), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func joinGame() {
        let value = codeInput.getValue()
        viewModel.joinGame(code: value)
        connectButton.isLoading = true
//        codeInput.toggleInput(true)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func handleTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: view)
        if(codeInput.frame.contains(location)) {
            codeInput.showKeyboard()
        } else {
            codeInput.DismissKeyboard()
        }
    }

    public func showError(errorString: String) {
        connectButton.isLoading = false
        let alert = UIAlertController(title: "Join Error", message: errorString, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

// MARK: - GestureDelegate
extension RoomCodeViewController: UIGestureRecognizerDelegate { }
