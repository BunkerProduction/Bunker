//
//  GameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit
import Combine

final class PlayerViewModel {
    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private var gameModelSubscriber: AnyCancellable?
    private var gameModel: Game? {
        didSet {
            updateDataSource()
        }
    }

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
    }

    private func updateDataSource() {
        guard let gameModel = gameModel else {
            return
        }
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
