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
        
        updateUI()
    }
    
    private func updateUI() {
        let theme = settings.appearance
        connectButton.setTheme(theme)
        logo.setTheme(theme)
        codeInput.setTheme(theme)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = UIColor.TextAndIcons.Primary.colorFor(theme)
        self.view.backgroundColor = .BackGround.LayerOne.colorFor(theme)
    }
    
    // MARK: - UI setup
    private func setupView() {
        view.addSubview(logo)
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 48)
        logo.pinCenter(to: view.centerXAnchor)
        
        view.addSubview(codeInput)
        codeInput.pin(to: view, [.left: 24, .right: 24])
        codeInput.pinTop(to: logo.bottomAnchor, 46)
        codeInput.setHeight(to: 105)
    }
    
    private func setButton() {
        view.addSubview(connectButton)
        
        connectButton.pin(to: view, [.left: 24, .right: 24])
        connectButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
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
    
    @objc
    private func handleTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: view)
        if(codeInput.frame.contains(location)) {
            codeInput.showKeyboard()
        } else {
            codeInput.DismissKeyboard()
        }
    }
}

// MARK: - GestureDelegate
extension RoomCodeViewController: UIGestureRecognizerDelegate { }
