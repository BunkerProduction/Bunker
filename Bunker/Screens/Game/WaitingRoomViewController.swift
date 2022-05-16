//
//  WaitingRoom.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 15.05.2022.
//

import UIKit

final class WaitingRoomViewController: UIViewController {
    private let roomCodeView = SplittedDigitInput(isPresenting: true)
    private let startGameButton = PrimaryButton()
    private let shareButton = PrimaryButton()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            WaitingCollectionViewCell.self,
            forCellWithReuseIdentifier: WaitingCollectionViewCell.reuseIdentifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private var viewModel: WaitingViewModel
    private var settings = UserSettings.shared
    
    // MARK:  - Init
    init() {
        viewModel = WaitingViewModel(collectionView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateUI()
    }
    
    // MARK: - UpdateUI
    private func updateUI() {
        let theme = settings.appearance
        startGameButton.setTheme(theme)
        shareButton.setTheme(theme)
        roomCodeView.setTheme(theme)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.TextAndIcons.Primary.colorFor(theme)
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
    }
    
    // MARK: - setup UI
    private func setupView() {
        setupNavBar()
        setButtons()
        setCodeView()
        
        view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.left: 24, .right: 24])
        collectionView.pinTop(to: roomCodeView.bottomAnchor)
        collectionView.pinBottom(to: shareButton.topAnchor)
    }
    
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Настройки"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setCodeView() {
        view.addSubview(roomCodeView)
        roomCodeView.pin(to: view, [.left: 24, .right: 24])
        roomCodeView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 46)
        roomCodeView.setHeight(to: 116)
    }
    
    private func setButtons() {
        shareButton.setTitle("Поделиться комнатой", for: .normal)
        startGameButton.setTitle("Начать игру", for: .normal)
        shareButton.addTarget(self, action: #selector(shareRoom), for: .touchUpInside)
        let sV = UIStackView(arrangedSubviews: [shareButton, startGameButton])
        sV.distribution = .fill
        sV.alignment = .fill
        sV.axis = .vertical
        sV.spacing = 16
        startGameButton.isHidden = true
        view.addSubview(sV)
        sV.pin(to: view, [.left: 24, .right: 24])
        sV.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
    }
    
    // MARK: - Interactions
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func shareRoom() {
        startGameButton.isHidden.toggle()
    }
}

// MARK: - GestureDelegate
extension WaitingRoomViewController: UIGestureRecognizerDelegate { }
