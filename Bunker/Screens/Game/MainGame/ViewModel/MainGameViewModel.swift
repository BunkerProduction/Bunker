//
//  MainGameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.07.2022.
//

import UIKit
import Combine
import CoreMIDI

final class MainGameViewModel: MainScreenLogic {
    typealias DataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private let progressCache = ProgressCache()
    private var gameModelSubscriber: AnyCancellable?
    private var kickPlayerSubscriber: AnyCancellable?
    private var isShowingKick: Bool = false
    private var kickedPlayer: PlayerKicked? {
        didSet {
            processKick()
        }
    }

    private var playersDictionary: [String: Player] = [:]
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
    init(
        collectionView: UICollectionView,
        gameCoordinator: GameCoordinator,
        gameScreen: MainGameScreen
    ) {
        self.coordinator = gameCoordinator
        self.collectionView = collectionView
        self.gameScreen = gameScreen

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

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? PlayerCollectionViewCell,
               let key = itemIdentifier as? String,
               let item = self.playersDictionary[key] {
                cell.progressCache = self.progressCache
                cell.configure(
                    player: item,
                    mode: self.gameModel?.gameState ?? .normal,
                    action: { [weak self] (playerID) in
                        if self?.gameModel?.hasVoted == false {
                            self?.networkService.sendVote(forPlayer: playerID)
                        }
                    },
                    canVote: self.gameModel?.hasVoted == false ? true : false
                )
                cell.setTheme(self.settings.appearance)
            }

            return cell
        }
        updateDataSource()
    }

    // MARK: - DataSource update
    private func updateDataSource() {
        guard let gameModel = gameModel else {
            return
        }
        
        let playersIdItemTupleArray = gameModel.players.map { ($0.UID, $0) }
        playersDictionary = Dictionary(uniqueKeysWithValues: playersIdItemTupleArray)

        switch gameModel.gameState {
        case .normal:
            var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
            snapshot.appendSections(["players"])
            snapshot.appendItems(gameModel.players.map { $0.UID }, toSection: "players")
            dataSource?.applySnapshotUsingReloadData(snapshot)
            updateHeaderView()
        case .voting:
            guard var newSnapshot = dataSource?.snapshot() else { return }
            newSnapshot.reconfigureItems(gameModel.players.map { $0.UID })

            updateHeaderView()

            dataSource?.apply(newSnapshot, animatingDifferences: true)
        case .finished:
            showFinishController(true)
        }
    }

    private func updateHeaderView() {
        guard let gameModel = gameModel, !isShowingKick else {
            return
        }

        switch gameModel.gameState {
            case .normal:
                if let playerWithTurn = gameModel.players.first(where: {$0.UID == gameModel.turn }) {
                    let text = "PLAYERS_TURN".localize(lan: settings.language) + "\(playerWithTurn.username)"
                    gameScreen?.setupHeaderView(model: .init(mode: .normal(text: text)))
                }
                progressCache.clearProgress()
            case .voting:
                gameScreen?.setupHeaderView(model: .init(mode: .voting))
            case .finished:
                return
        }
    }

    private func showNotificationInHeader() {
        guard let kickedPlayer = kickedPlayer else {
            return
        }
        guard let playerToKick = gameModel?.players.first(where: { $0.UID == kickedPlayer.id }) else { return }
        isShowingKick = true
        let text = "PLAYER_EXCLUDED".localize(lan: settings.language) + "\(playerToKick.username)"
        gameScreen?.setupHeaderView(model: .init(mode: .normal(text: text)))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShowingKick = false
            self.updateHeaderView()
        }
    }

    // MARK: - Player Kick
    private func processKick() {
        guard let kickedPlayer = kickedPlayer,
              let gameModel = gameModel
        else {
            return
        }

        if gameModel.myPlayer.UID != kickedPlayer.id {
            showNotificationInHeader()
        } else {
            showFinishController()
        }
    }

    private func showFinishController(_ isFinish: Bool = false) {
        guard let coordinator = coordinator else {
            return
        }

        let vc = FinishViewController(coordinator)
        if isFinish {
            vc.configure(.won)
        } else {
            vc.configure(.lost)
        }
        vc.modalPresentationStyle = .overFullScreen
        coordinator.presentViewController(vc)
    }

    // MARK: - Binding
    private func binding() {
        gameModelSubscriber = networkService.gameModelRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.gameModel, on: self)

        kickPlayerSubscriber = networkService.kickedPlayerRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.kickedPlayer, on: self)
    }

    // MARK: - Public Methods
    private func unbind() {
        gameModelSubscriber?.cancel()
        kickPlayerSubscriber?.cancel()
    }

    func cellSelected(indexPath: IndexPath) {
        if let id = dataSource?.itemIdentifier(for: indexPath) as? String,
           let player = playersDictionary[id] {
            let playerViewController = PlayerDetailsViewController(player: player)
            let navVC = UINavigationController(rootViewController: playerViewController)
            playerViewController.modalPresentationStyle = .pageSheet
            coordinator?.presentViewController(navVC)
        }
    }
}
