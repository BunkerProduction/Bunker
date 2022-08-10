//
//  ThreatsViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.07.2022.
//

import UIKit
import Combine
import AVFoundation

final class ThreatViewModel: ThreatsLogic {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias DifSnapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

    enum Section: String {
        case threats
        case catastrophe
        case bunker
        case exit
    }

    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private var gameModelSubscriber: AnyCancellable?
    private var gameModel: Game? {
        didSet {
            updateDataSource()
        }
    }
    private var dataSource: DataSource?

    private weak var coordinator: GameCoordinator?
    private weak var collectionView: UICollectionView?

    var sections = [Section]()

    // MARK: - Init
    init(collectionView: UICollectionView, gameCoordinator: GameCoordinator) {
        self.coordinator = gameCoordinator
        self.collectionView = collectionView
        binding()
        createDataSource()
    }

    // MARK: - DataSource
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
                    cell.configure(icon: "⚡️", type: "Условие", description: "The AI control of the bunker «stuck out» and blocks life support - it is necessary to prove the soulless computer that there are breathing living people in the bunker. \n\nThe test is based on checking the unique difference between humans and robots - the ability to create. You need to go through it.")
                    cell.setTheme(self.settings.appearance)
                }
                return cell
            case .catastrophe:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CatastrpoheCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                if let cell = cell as? CatastrpoheCollectionViewCell,
                   let catastrophe = itemIdentifier as? Catastrophe {
                    cell.configure(
                        icon: catastrophe.icon,
                        title: catastrophe.name,
                        type: "Аппокалипсис",
                        description: catastrophe.fullDesciption
                    )
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
        guard let gameModel = gameModel else {
            return
        }
        var snapshot = DifSnapshot()
        snapshot.appendSections([.threats, .catastrophe, .exit])
        snapshot.appendItems(["text","1234"], toSection: .threats)
        snapshot.appendItems([gameModel.gamePreferences.catastrophe], toSection: .catastrophe)
        snapshot.appendItems(["dummy"], toSection: .exit)
        sections = [.threats, .catastrophe, .exit]

        dataSource?.apply(snapshot)
    }

    // MARK: - Binding
    private func binding() {
        gameModelSubscriber = networkService.gameModelRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.gameModel, on: self)
    }

    private func unbind() {
        gameModelSubscriber?.cancel()
    }

    // MARK: - External methods
    public func exitGame() {
        coordinator?.exitGame()
    }
}
