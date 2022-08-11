//
//  PlayerViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit

final class PlayerViewController: UIViewController {
    private let settings = UserSettings.shared

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            AttributeCollectionViewCell.self,
            forCellWithReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()
    
    private var viewModel: PlayerViewModel?

    // MARK: - Init
    init(_ coordinator: GameCoordinator) {
        super.init(nibName: nil, bundle: nil)

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
    }

    private func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "My Characteristics"
    }
}
