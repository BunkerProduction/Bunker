//
//  ThreatsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit

final class ThreatsViewController: UIViewController {
    private let settings = UserSettings.shared

    private var collectionView: UICollectionView?

    // MARK: - Init
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
        setupCollectionView()
    }

    private func setupCollectionView() {
        
    }

    // MARK: - Setup NavBar
    private func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "Appocalypse"
    }
}
