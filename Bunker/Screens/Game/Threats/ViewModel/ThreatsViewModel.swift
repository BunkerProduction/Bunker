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
    typealias DataSource = UICollectionViewDiffableDataSource<ThreatsSection, AnyHashable>
    typealias DifSnapshot = NSDiffableDataSourceSnapshot<ThreatsSection, AnyHashable>

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

    var sections = [ThreatsSection]()

    // MARK: - Init
    init(collectionView: UICollectionView, gameCoordinator: GameCoordinator) {
        self.coordinator = gameCoordinator
        self.collectionView = collectionView
        binding()
        createDataSource()
    }

    deinit {
        unbind()
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
            case .conditions:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ConditionCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                if let cell = cell as? ConditionCollectionViewCell,
                    let item  = itemIdentifier as? ShelterCondition {
                    cell.configure(icon: "⚡️", type: "Условие", description: item.description)
                    cell.setTheme(self.settings.appearance)
                }
                return cell
            case .shelter:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GameInfoCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                if let cell = cell as? GameInfoCollectionViewCell,
                   let item = itemIdentifier as? Shelter {
                    cell.configure(icon: item.icon, title: item.name, type: "Бункер", description: item.description)
                    cell.setTheme(self.settings.appearance)
                }

                return cell
            case .catastrophe:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GameInfoCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                if let cell = cell as? GameInfoCollectionViewCell,
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
            case .exit:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                if let cell = cell as? ButtonCollectionViewCell {
                    cell.configure("Выйти из игры")
                    cell.setTheme(self.settings.appearance, true)
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

        let conditions: [ShelterCondition] = gameModel.gamePreferences.conditions.filter { $0.isExposed }

        snapshot.appendSections([.conditions, .shelter, .catastrophe, .exit])
        snapshot.appendItems(conditions, toSection: .conditions)
        snapshot.appendItems([gameModel.gamePreferences.shelter], toSection: .shelter)
        snapshot.appendItems([gameModel.gamePreferences.catastrophe], toSection: .catastrophe)
        snapshot.appendItems(["dummy"], toSection: .exit)
        sections = [.conditions, .shelter, .catastrophe, .exit]

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
