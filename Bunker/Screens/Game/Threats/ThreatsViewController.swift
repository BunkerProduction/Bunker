//
//  ThreatsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit

final class ThreatsViewController: UIViewController, ThreatsScreen {
    private enum Consts {
        static let itemSpacing: CGFloat = 20
        static let sectionInsets: CGFloat = 16
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: Consts.sectionInsets,
            right: 0
        )
        layout.minimumInteritemSpacing = Consts.itemSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ConditionCollectionViewCell.self,
            forCellWithReuseIdentifier: ConditionCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            GameInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: GameInfoCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            ButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

    private let settings = UserSettings.shared
    private var viewModel: ThreatsLogic?

    // MARK: - Init
    init(_ coordinator: GameCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ThreatViewModel(collectionView: collectionView, gameCoordinator: coordinator)
    }

    @available(*, unavailable)
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
        self.navigationController?.navigationBar.backgroundColor = .Background.LayerOne.colorFor(theme)
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
    }

    // MARK: - UIsetup
    private func setupView() {
        setupNavBar()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        view.addSubview(collectionView)

        collectionView.pin(to: view, [.left, .right, .bottom])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }

    private func showAlert() {
        let alertView = UIAlertController(
            title: "EXIT".localize(lan: settings.language),
            message: "EXIT_MESSAGE".localize(lan: settings.language),
            preferredStyle: .alert)
        alertView.addAction(
            UIAlertAction(
                title: "CANCEL".localize(lan: settings.language),
                style: .cancel,
                handler: nil
            )
        )
        alertView.addAction(
            UIAlertAction(
                title: "EXIT".localize(lan: settings.language),
                style: .destructive,
                handler: {_ in
                    self.viewModel?.exitGame()
                }
            )
        )
        self.present(alertView, animated: true)
    }

    // MARK: - Setup NavBar
    private func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "APOCALYPSE".localize(lan: settings.language)
    }
}

// MARK: - CollectionViewDelegate
extension ThreatsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel?.sections[indexPath.section] == ThreatsSection.exit else { return }
        showAlert()
    }
}
