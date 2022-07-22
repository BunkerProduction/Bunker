//
//  MainGameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.07.2022.
//

import UIKit

final class MainGameViewModel {
    typealias DataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private weak var coordinator: GameCoordinator?
    private weak var collectionView: UICollectionView?

    // MARK: - Init
    init(collectionView: UICollectionView, gameCoordinator: GameCoordinator) {
        self.coordinator = gameCoordinator
        self.collectionView = collectionView

        createDataSource()
    }

    private func createDataSource() {

    }
}
