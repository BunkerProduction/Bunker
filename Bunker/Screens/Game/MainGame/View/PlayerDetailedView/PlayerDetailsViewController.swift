//
//  PlayerDetailsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 20.08.2022.
//

import UIKit

final class PlayerDetailsViewController: UIViewController {
    private let settings = UserSettings.shared
    private let player: Player

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            AttributeCollectionViewCell.self,
            forCellWithReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()
    private var viewModel: PlayerDetailsViewModel?

    init(player: Player) {
        self.player = player
        super.init(nibName: nil, bundle: nil)

        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        viewModel = PlayerDetailsViewModel(collectionView: collectionView, player: player)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        setupView()
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
        self.title = "\(player.username) Characteristics"
    }

    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
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
        }
        return layout
    }
}
