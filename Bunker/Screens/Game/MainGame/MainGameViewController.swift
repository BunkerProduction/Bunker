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
    private var firstSpecialView = GameSpecialCardView()
    private var secondScecialView = GameSpecialCardView()

    private var headerHeightConstraint: NSLayoutConstraint?

    private var specialsStackView = UIStackView()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ScreenSize.Width - 48, height: 48)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            PlayerCollectionViewCell.self,
            forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)

        return collectionView
    }()

    private var viewModel: MainGameViewModel?

    // MARK: - Init
    init(_ coordinator: GameCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = MainGameViewModel(collectionView: collectionView, gameCoordinator: coordinator, gameScreen: self)
        collectionView.delegate = self
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
        firstSpecialView.setTheme(theme)
        secondScecialView.setTheme(theme)
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
        headerHeightConstraint = headerView.setHeight(to: 80)

        [firstSpecialView, secondScecialView].forEach {
            specialsStackView.addArrangedSubview($0)
        }
        specialsStackView.distribution = .fillEqually
        specialsStackView.alignment = .fill
        specialsStackView.axis = .horizontal
        specialsStackView.spacing = 16

        view.addSubview(specialsStackView)
        specialsStackView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 150)
        specialsStackView.pin(to: view, [.left: 24, .right: 24])
        specialsStackView.setHeight(to: 130)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.pinTop(to: headerView.bottomAnchor, 0)
        collectionView.pin(to: view, [.left: 24, .right: 24, .bottom: 0])
        collectionView.pinBottom(to: specialsStackView.topAnchor)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.cellSelected(indexPath: indexPath)
    }
}

extension MainGameViewController: MainGameScreen {
    func setupHeaderView(model: GameHeaderView.ViewModel) {
        headerView.configure(model)
        switch model.mode {
            case .normal:
            UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.headerHeightConstraint?.constant = 80
                    self?.view.layoutIfNeeded()
                }
            case .voting:
                headerHeightConstraint?.constant = 132
        }
    }
}
