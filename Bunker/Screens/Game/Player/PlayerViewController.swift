//
//  PlayerViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit

final class PlayerViewController: UIViewController, PlayerScreen {
    private let settings = UserSettings.shared

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            AttributeCollectionViewCell.self,
            forCellWithReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            ButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()
    
    private var viewModel: PlayerScreenLogic?

    // MARK: - Init
    init(_ coordinator: GameCoordinator) {
        super.init(nibName: nil, bundle: nil)

        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        collectionView.delegate = self
        self.viewModel = PlayerViewModel(collectionView: collectionView, gameCoordinator: coordinator)
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
        view.addSubview(collectionView)
        collectionView.pin(to: view, [.left, .right, .bottom])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }

    private func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "My characteristics"
    }

    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            if case 0 = sectionIndex {
                let itemSide = (ScreenSize.Width - 48 - 16) / 2
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(itemSide),
                    heightDimension: .absolute(itemSide)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(itemSide)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                    leading: .none,
                    top: .fixed(16),
                    trailing: .none,
                    bottom: .none
                )
                group.interItemSpacing = .fixed(16)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 20, trailing: 24)

                return section
            } else {
                let itemSide = (ScreenSize.Width - 48)
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(itemSide),
                    heightDimension: .absolute(48)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(48)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                    leading: .none,
                    top: .fixed(16),
                    trailing: .none,
                    bottom: .none
                )
                group.interItemSpacing = .fixed(16)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 110, trailing: 24)

                return section
            }
        }
        return layout
    }
}

// MARK: - CollectionViewDelegate
extension PlayerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.cellSelected(indexPath: indexPath)
    }
}
