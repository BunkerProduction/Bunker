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
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ScreenSize.Width - 48, height: 48)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            WaitingCollectionViewCell.self,
            forCellWithReuseIdentifier: WaitingCollectionViewCell.reuseIdentifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private var viewModel: WaitingViewModel?
    private var settings = UserSettings.shared
    
    // MARK:  - Init
    init(data roomModel: WaitingRoom) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = WaitingViewModel(collectionView, roomCodeView, roomModel, viewController: self)
    }
    
    deinit {
        print("____Waiting Controller was deinitialized_______")
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
        self.navigationItem.title = "WAITING_ROOM".localize(lan: settings.language)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setCodeView() {
        roomCodeView.setTitleLabel("ENTER_ROOM_NUMBER".localize(lan: settings.language))

        view.addSubview(roomCodeView)
        roomCodeView.pin(to: view, [.left: 24, .right: 24])
        roomCodeView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 46)
        roomCodeView.setHeight(to: 116)
    }
    
    private func setButtons() {
        shareButton.setTitle("SHARE_ROOM".localize(lan: settings.language), for: .normal)
        startGameButton.setTitle("START_GAME".localize(lan: settings.language), for: .normal)
        
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareRoom), for: .touchUpInside)
        
        let sV = UIStackView(arrangedSubviews: [shareButton, startGameButton])
        sV.distribution = .fill
        sV.alignment = .fill
        sV.axis = .vertical
        sV.spacing = 16
        
        view.addSubview(sV)
        sV.pin(to: view, [.left: 24, .right: 24])
        sV.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 24)
    }
    
    // MARK: - Interactions
    @objc
    private func goBack() {
        viewModel?.disconnect()
    }
    
    @objc
    private func shareRoom() {
        viewModel?.shareRoom()
    }
    
    @objc
    private func startGame() {
        viewModel?.startGame()
    }
    
    public func isStartGameVisible(_ isVisible: Bool) {
        startGameButton.isHidden = !isVisible
    }

    public func shareLink(link: URL) {
        let activityController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        present(activityController, animated: true, completion: nil)
    }

    public func showError(errorString: String) {
        let alert = UIAlertController(title: "START_ERROR".localize(lan: settings.language), message: errorString, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "OK".localize(lan: settings.language), style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

extension WaitingRoomViewController: UIGestureRecognizerDelegate { }
