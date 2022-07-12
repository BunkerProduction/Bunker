//
//  ThreatsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit

final class ThreatsViewController: UIViewController {
    private let settings = UserSettings.shared

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ConditionCollectionViewCell.self,
            forCellWithReuseIdentifier: ConditionCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    private var viewModel: ThreatViewModel?

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ThreatViewModel(collectionView: collectionView)
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
        self.navigationController?.navigationBar.backgroundColor = .Background.LayerOne.colorFor(theme)
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
    }

    // MARK: - UIsetup
    private func setupView() {
        setupNavBar()
        setupCollectionView()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.pin(to: view, [.left, .right, .bottom])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }

    // MARK: - Setup NavBar
    private func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "Appocalypse"
    }
}
