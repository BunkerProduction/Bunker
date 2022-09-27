//
//  MainGameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.07.2022.
//

import UIKit
import Combine
import CoreMIDI

final class MainGameViewModel {
    typealias DataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private let progressCache = ProgressCache()
    private var gameModelSubscriber: AnyCancellable?
    private var gameModel: Game? {
        didSet {
            updateDataSource()
        }
    }
    private var dataSource: DataSource?

    private weak var coordinator: GameCoordinator?
    private weak var gameScreen: MainGameScreen?
    private weak var collectionView: UICollectionView?

    // MARK: - Init
    init(collectionView: UICollectionView, gameCoordinator: GameCoordinator, gameScreen: MainGameScreen) {
        self.coordinator = gameCoordinator
        self.collectionView = collectionView
        self.gameScreen = gameScreen
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
                cell.progressCache = self.progressCache
                cell.configure(player: item, votingProgress: Double.random(in: 0..<1))
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

        switch gameModel.gameState {
            case .normal:
                if let playerWithTurn = gameModel.players.first(where: {$0.UID == gameModel.turn }) {
                    gameScreen?.setupHeaderView(model: .init(mode: .normal(text: "Ход игрока: \(playerWithTurn.username)")))
                }
                progressCache.clearProgress()
            case .voting:
                gameScreen?.setupHeaderView(model: .init(mode: .voting))
        }

        dataSource?.applySnapshotUsingReloadData(snapshot)
    }

    // MARK: - Binding
    private func binding() {
        gameModelSubscriber = networkService.gameModelRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.gameModel, on: self)
    }

    // MARK: - Public Methods
    private func unbind() {
        gameModelSubscriber?.cancel()
    }

    func cellSelected(indexPath: IndexPath) {
        if let player = dataSource?.itemIdentifier(for: indexPath) as? Player {
            let playerViewController = PlayerDetailsViewController(player: player)
            let navVC = UINavigationController(rootViewController: playerViewController)
            playerViewController.modalPresentationStyle = .pageSheet
            coordinator?.presentViewController(navVC)
        }
    }
}
