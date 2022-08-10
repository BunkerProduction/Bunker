//
//  MainGameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.07.2022.
//

import UIKit
import Combine

final class MainGameViewModel {
    typealias DataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

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

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? PlayerCollectionViewCell,
               let item = itemIdentifier as? Player {
                cell.configure(name: item.username)
                cell.setTheme(self.settings.appearance)
            }

            return cell
        }
        updateDataSource()
    }

    private func updateDataSource() {
        guard let gameModel = gameModel else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        snapshot.appendSections(["players"])
        snapshot.appendItems(gameModel.players, toSection: "players")
//        snapshot.appendSections([.threats, .catastrophe, .exit])
//        snapshot.appendItems(["text","1234"], toSection: .threats)
//        snapshot.appendItems([gameModel.gamePreferences.catastrophe], toSection: .catastrophe)
//        snapshot.appendItems(["dummy"], toSection: .exit)
//        sections = [.threats, .catastrophe, .exit]

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
}
