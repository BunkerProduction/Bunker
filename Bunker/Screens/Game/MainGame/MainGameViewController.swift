//
//  MainGameViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit

final class MainGameViewController: UIViewController {
    private let settings = UserSettings.shared

    private var headerView = GameHeaderView()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            PlayerCollectionViewCell.self,
            forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    private var viewModel: MainGameViewModel?

    // MARK: - Init
    init(_ coordinator: GameCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = MainGameViewModel(collectionView: collectionView, gameCoordinator: coordinator)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        updateUI()
    }
    
    // MARK: - UpdateUI
    private func updateUI() {
        let theme = settings.appearance
        self.navigationController?.navigationBar.backgroundColor = .Background.LayerOne.colorFor(theme)
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
        headerView.setTheme(theme)
    }

    // MARK: - Setup UI
    private func setupView() {
        setupStaticViews()
        setupCollectionView()
    }

    private func setupStaticViews() {
        view.addSubview(headerView)

        headerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        headerView.pin(to: view, [.left: 24, .right: 24])
        headerView.setHeight(to: 132)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.pinTop(to: headerView.bottomAnchor, 0)
        collectionView.pin(to: view, [.left: 24, .right: 24, .bottom: 0])
    }

    // MARK: - Setup NavBar
    private func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "Game and Participants"
    }
}

// MARK: - CollectionViewDelegate
extension MainGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
