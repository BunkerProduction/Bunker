//
//  ThreatsViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.07.2022.
//

import UIKit

final class ThreatViewModel {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias DifSnapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

    enum Section: String {
        case threats
        case bunker
        case exit
    }

    var sections = [Section]()
    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private var dataSource: DataSource?
    private weak var collectionView: UICollectionView?

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

            let section = self.sections[indexPath.section]
            switch section {
            case .threats:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ConditionCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                if let cell = cell as? ConditionCollectionViewCell {
                    cell.configure(icon: "f", type: "radnom", description: "some random")
                    cell.setTheme(self.settings.appearance)
                }
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                if let cell = cell as? ButtonCollectionViewCell {
                    cell.configure("Выйти из игры")
                    cell.setTheme(self.settings.appearance)
                }

                return cell
            }
        }
        updateDataSource()
    }

    private func updateDataSource() {
        var snapshot = DifSnapshot()
        snapshot.appendSections([.threats, .exit])
        snapshot.appendItems(["text"], toSection: .threats)
        snapshot.appendItems(["dummy"], toSection: .exit)
        sections = [.threats, .exit]

        dataSource?.apply(snapshot)
    }
}
