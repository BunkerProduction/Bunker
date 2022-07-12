//
//  ThreatsViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.07.2022.
//

import UIKit

final class ThreatViewModel {
    typealias DataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>
    typealias DifSnapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>

    private var dataSource: DataSource?
    private weak var collectionView: UICollectionView?
    private let settings = UserSettings.shared

    // MARK: - Init
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView

        createDataSource()
    }

    private func createDataSource() {
        guard let collectionView = collectionView else {
            return
        }
        self.dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ConditionCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? ConditionCollectionViewCell {
                cell.configure(icon: "f", type: "radnom", description: "some random")
                cell.setTheme(self.settings.appearance)
            }

            return cell
        }
        updateDataSource()
    }

    private func updateDataSource() {
        // TODO: -
        var snapshot = DifSnapshot()
        snapshot.appendSections(["test"])
        snapshot.appendItems(["text"], toSection: "test")

        dataSource?.apply(snapshot)
    }
}
