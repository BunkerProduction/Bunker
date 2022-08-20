//
//  PlayerDetailsViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 21.08.2022.
//

import UIKit

final class PlayerDetailsViewModel: NSObject {
    private let settings = UserSettings.shared
    private var dataSource: [Attribute] = []

    private weak var collectionView: UICollectionView?

    // MARK: - Init
    init(collectionView: UICollectionView, player: Player) {
        super.init()

        self.dataSource = player.attributes.filter { $0.isExposed }
        self.collectionView = collectionView
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension PlayerDetailsViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? AttributeCollectionViewCell {
            cell.configure(dataSource[indexPath.row], isBlurable: false)
            cell.setTheme(settings.appearance)
        }

        return cell
    }
}
